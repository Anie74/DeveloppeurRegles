"
Detect return instead of ^
"
Class {
	#name : 'ReReturnKeywordRule',
	#superclass : 'ReExclusivelyBeginnersRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'manifest' }
ReReturnKeywordRule class >> ruleName [
    ^ 'ReturnKeyword'
]

{ #category : 'checking' }
ReReturnKeywordRule >> checkMethod: aMethod [
    (self includesWord: 'return' in: aMethod sourceCode) ifTrue: [
        ^ { (ReTrivialCritique for: aMethod by: self)
            tinyHint: 'Use ^ instead of return';
            yourself } ].
    ^ #()
]

{ #category : 'accessing' }
ReReturnKeywordRule >> group [
    ^ 'Noobs Errors'
]

{ #category : 'accessing' }
ReReturnKeywordRule >> name [
    ^ 'return instead of ^'
]

{ #category : 'accessing' }
ReReturnKeywordRule >> rationale [
    ^ 'In Pharo, you must return with the symbol ^ '
]

{ #category : 'accessing' }
ReReturnKeywordRule >> severity [
    ^ #error
]
