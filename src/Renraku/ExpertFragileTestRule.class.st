"
Test fragile
"
Class {
	#name : 'ExpertFragileTestRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ExpertFragileTestRule class >> ruleName [
    ^ 'Test fragile'
]

{ #category : 'manifest' }
ExpertFragileTestRule class >> uniqueIdentifierName [
    ^ 'FragileTest'
]

{ #category : 'checking' }
ExpertFragileTestRule >> checkMethod: aMethod [
    | critiques unstableNames |
    (self isTestMethod: aMethod) ifFalse: [ ^ #() ].
    critiques := OrderedCollection new.
    unstableNames := Set new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [ self reflectiveSelectors includes: node selector ])
            ifTrue: [
                critiques add: (self
                    newCritiqueFor: aMethod
                    hint: 'Test fragile : accès réflexif à l''état interne (',
                        node selector, ')') ].
        (node isMessage and: [
            (node selector beginsWith: 'assert') and: [ self hasTextualFormIn: node ] ])
            ifTrue: [
                critiques add: (self
                    newCritiqueFor: aMethod
                    hint: 'Test fragile : assertion sur la représentation texte (printString)') ].
        (node isVariable and: [ self unstableClassNames includes: node name ])
            ifTrue: [ unstableNames add: node name ] ].
    unstableNames do: [ :each |
        critiques add: (self
            newCritiqueFor: aMethod
            hint: 'Test fragile : dépend de l''horloge ou du hasard (', each, ')') ].
    ^ critiques
]

{ #category : 'accessing' }
ExpertFragileTestRule >> group [
    ^ 'Tests'
]

{ #category : 'private' }
ExpertFragileTestRule >> hasTextualFormIn: anAssertionNode [
    anAssertionNode arguments do: [ :argument |
        argument nodesDo: [ :inner |
            (inner isMessage and: [ #(#printString #displayString) includes: inner selector ])
                ifTrue: [ ^ true ] ] ].
    ^ false
]

{ #category : 'private' }
ExpertFragileTestRule >> isTestMethod: aMethod [
    ^ (aMethod methodClass inheritsFrom: TestCase)
        and: [ aMethod selector beginsWith: 'test' ]
]

{ #category : 'accessing' }
ExpertFragileTestRule >> name [
    ^ 'Test fragile'
]

{ #category : 'accessing' }
ExpertFragileTestRule >> rationale [
    ^ 'Un test lié à un détail d''implémentation (état interne, format d''affichage, horloge, hasard) casse sans que le comportement ait changé'
]

{ #category : 'accessing' }
ExpertFragileTestRule >> reflectiveSelectors [
    ^ #(#instVarNamed: #instVarNamed:put: #instVarAt: #instVarAt:put:)
]

{ #category : 'accessing' }
ExpertFragileTestRule >> severity [
    ^ #warning
]

{ #category : 'accessing' }
ExpertFragileTestRule >> unstableClassNames [
    ^ #('DateAndTime' 'Date' 'Time' 'Random' 'Delay')
]
