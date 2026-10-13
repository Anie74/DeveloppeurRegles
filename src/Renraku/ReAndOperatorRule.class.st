"
Detect and operator errors
"
Class {
	#name : 'ReAndOperatorRule',
	#superclass : 'ReExclusivelyBeginnersRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'manifest' }
ReAndOperatorRule class >> ruleName [
    ^ 'AndOperator'
]

{ #category : 'checking' }
ReAndOperatorRule >> checkMethod: aMethod [
    (aMethod sourceCode includesSubstring: '&&') ifTrue: [
        ^ { (ReTrivialCritique for: aMethod by: self)
            tinyHint: 'Utilisez and: au lieu de &&';
            yourself } ].
    ^ #()
]

{ #category : 'accessing' }
ReAndOperatorRule >> group [
    ^ 'Noobs Errors'
]

{ #category : 'accessing' }
ReAndOperatorRule >> name [
    ^ '&& instead of and:'
]

{ #category : 'accessing' }
ReAndOperatorRule >> rationale [
    ^ 'In Pharo, logic operators AND is written and: not &&'

]

{ #category : 'accessing' }
ReAndOperatorRule >> severity [
    ^ #error
]
