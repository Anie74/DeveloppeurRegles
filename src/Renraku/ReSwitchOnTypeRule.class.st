Class {
	#name : 'ReSwitchOnTypeRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReSwitchOnTypeRule class >> ruleName [
    ^ 'Tests de type multiples'
]

{ #category : 'manifest' }
ReSwitchOnTypeRule class >> uniqueIdentifierName [
    ^ 'SwitchOnType'
]

{ #category : 'checking' }
ReSwitchOnTypeRule >> checkMethod: aMethod [
    | checks |
    checks := 0.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [ self typeTestSelectors includes: node selector ])
            ifTrue: [ checks := checks + 1 ] ].
    checks >= self minimumChecks ifTrue: [
        ^ { self
            newCritiqueFor: aMethod
            hint: checks printString, ' tests de type : utilisez le polymorphisme' } ].
    ^ #()
]

{ #category : 'accessing' }
ReSwitchOnTypeRule >> group [
    ^ 'Conception avancée'
]

{ #category : 'accessing' }
ReSwitchOnTypeRule >> minimumChecks [
    ^ 3
]

{ #category : 'accessing' }
ReSwitchOnTypeRule >> name [
    ^ 'Tests de type multiples'
]

{ #category : 'accessing' }
ReSwitchOnTypeRule >> rationale [
    ^ 'Plusieurs tests de type dans une méthode indiquent qu''un envoi polymorphe serait plus adapté'
]

{ #category : 'accessing' }
ReSwitchOnTypeRule >> severity [
    ^ #warning
]

{ #category : 'accessing' }
ReSwitchOnTypeRule >> typeTestSelectors [
    ^ #(#isKindOf: #isMemberOf: #isString #isNumber #isInteger #isFloat
        #isSymbol #isCollection #isCharacter)
]
