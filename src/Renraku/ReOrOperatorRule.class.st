"
Detect using Or logic operators
"
Class {
	#name : 'ReOrOperatorRule',
	#superclass : 'ReExclusivelyBeginnersRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'manifest' }
ReOrOperatorRule class >> ruleName [
    ^ 'OrOperator'
]

{ #category : 'checking' }
ReOrOperatorRule >> checkMethod: aMethod [
    (aMethod sourceCode includesSubstring: '||') ifTrue: [
        ^ { (ReTrivialCritique for: aMethod by: self)
            tinyHint: 'Utilisez or: au lieu de ||';
            yourself } ].
    ^ #()
]

{ #category : 'accessing' }
ReOrOperatorRule >> group [
    ^ 'Noobs Errors'

]

{ #category : 'accessing' }
ReOrOperatorRule >> name [
    ^ '|| instead of or:'


]

{ #category : 'accessing' }
ReOrOperatorRule >> rationale [
    ^ 'In Pharo, logic operator OR is written or: and not ||'
]

{ #category : 'accessing' }
ReOrOperatorRule >> severity [
    ^ #error
]
