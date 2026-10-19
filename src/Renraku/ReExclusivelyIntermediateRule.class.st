"
Classify intermediate developpers
"
Class {
	#name : 'ReExclusivelyIntermediateRule',
	#superclass : 'ReAbstractRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'testing' }
ReExclusivelyIntermediateRule class >> conditionalNodesIn: aMethod receiverSelectors: aCollection [
    "Messages ifTrue:/ifFalse:... dont le receveur est un message de aCollection (ex: isNil)"
    | found |
    found := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [
            (#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:) includes: node selector) and: [
                node receiver isMessage and: [
                    aCollection includes: node receiver selector ] ] ])
            ifTrue: [ found add: node ] ].
    ^ found
]

{ #category : 'testing' }
ReExclusivelyIntermediateRule class >> countWord: aWord in: sourceCode [
    "Nombre d'occurrences de aWord comme mot entier"
    | count start index before after |
    count := 0.
    start := 1.
    [ index := sourceCode indexOfSubCollection: aWord startingAt: start.
      index > 0 ] whileTrue: [
        before := index > 1
            ifTrue: [ sourceCode at: index - 1 ]
            ifFalse: [ Character space ].
        after := (index + aWord size) <= sourceCode size
            ifTrue: [ sourceCode at: index + aWord size ]
            ifFalse: [ Character space ].
        (before isAlphaNumeric or: [ after isAlphaNumeric ])
            ifFalse: [ count := count + 1 ].
        start := index + 1 ].
    ^ count

]

{ #category : 'testing' }
ReExclusivelyIntermediateRule class >> isAbstract [
    ^ self == ReExclusivelyIntermediateRule
]

{ #category : 'testing' }
ReExclusivelyIntermediateRule class >> isBooleanLiteralNode: aNode in: aMethod [
    ^ #('true' 'false') includes: (self sourceTextOf: aNode in: aMethod)
]

{ #category : 'testing' }
ReExclusivelyIntermediateRule class >> newCritiqueFor: aMethod hint: aString [
    ^ (ReTrivialCritique for: aMethod by: self)
        tinyHint: aString;
        yourself
]

{ #category : 'testing' }
ReExclusivelyIntermediateRule class >> sourceTextOf: aNode in: aMethod [
    "Texte source exact d'un nœud de l'AST"
    ^ aMethod sourceCode copyFrom: aNode start to: aNode stop
]

{ #category : 'private' }
ReExclusivelyIntermediateRule >> conditionalNodesIn: aMethod receiverSelectors: aCollection [
    "Messages ifTrue:/ifFalse:... dont le receveur est un message de aCollection (ex: isNil)"
    | found |
    found := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [
            (#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:) includes: node selector) and: [
                node receiver isMessage and: [
                    aCollection includes: node receiver selector ] ] ])
            ifTrue: [ found add: node ] ].
    ^ found
]

{ #category : 'private' }
ReExclusivelyIntermediateRule >> countWord: aWord in: sourceCode [
    "Nombre d'occurrences de aWord comme mot entier"
    | count start index before after |
    count := 0.
    start := 1.
    [ index := sourceCode indexOfSubCollection: aWord startingAt: start.
      index > 0 ] whileTrue: [
        before := index > 1
            ifTrue: [ sourceCode at: index - 1 ]
            ifFalse: [ Character space ].
        after := (index + aWord size) <= sourceCode size
            ifTrue: [ sourceCode at: index + aWord size ]
            ifFalse: [ Character space ].
        (before isAlphaNumeric or: [ after isAlphaNumeric ])
            ifFalse: [ count := count + 1 ].
        start := index + 1 ].
    ^ count
]

{ #category : 'private' }
ReExclusivelyIntermediateRule >> isBooleanLiteralNode: aNode in: aMethod [
    ^ #('true' 'false') includes: (self sourceTextOf: aNode in: aMethod)
]

{ #category : 'private' }
ReExclusivelyIntermediateRule >> newCritiqueFor: aMethod hint: aString [
    ^ (ReTrivialCritique for: aMethod by: self)
        tinyHint: aString;
        yourself
]

{ #category : 'private' }
ReExclusivelyIntermediateRule >> sourceTextOf: aNode in: aMethod [
    "Texte source exact d'un nœud de l'AST"
    ^ aMethod sourceCode copyFrom: aNode start to: aNode stop

]

{ #category : 'accessing' }
ReExclusivelyIntermediateRule >> uniqueIdentifierName [
^ 'Intermediate developpers rule'
]
