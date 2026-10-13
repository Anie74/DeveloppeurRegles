"
Detect Self instead of self.
"
Class {
	#name : 'ReSelfCapitalizationRule',
	#superclass : 'ReExclusivelyBeginnersRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'manifest' }
ReSelfCapitalizationRule class >> uniqueIdentifierName [
    ^ 'SelfCapitalization'
]

{ #category : 'checking' }
ReSelfCapitalizationRule >> checkMethod: aMethod [
    (self includesWord: 'Self' in: aMethod sourceCode) ifTrue: [
        ^ { (ReTrivialCritique for: aMethod by: self)
            tinyHint: 'Self doit être écrit self (minuscules)';
            yourself } ].
    ^ #()
]

{ #category : 'accessing' }
ReSelfCapitalizationRule >> group [
    ^ 'Noobs Errors '
]

{ #category : 'accessing' }
ReSelfCapitalizationRule >> name [
    ^ 'Self instead of self'
]

{ #category : 'accessing' }
ReSelfCapitalizationRule >> rationale [
    ^ 'In Pharo, self is written in lowercase'
]

{ #category : 'accessing' }
ReSelfCapitalizationRule >> severity [
    ^ #error

]
