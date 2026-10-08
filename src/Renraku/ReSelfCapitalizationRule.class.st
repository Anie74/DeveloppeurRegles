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
    ^ 'Erreurs débutant'
]

{ #category : 'private' }
ReSelfCapitalizationRule >> includesWord: aWord in: sourceCode [
    | start index before after |
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
            ifFalse: [ ^ true ].
        start := index + 1 ].
    ^ false
]

{ #category : 'accessing' }
ReSelfCapitalizationRule >> name [
    ^ 'Self au lieu de self'
]

{ #category : 'accessing' }
ReSelfCapitalizationRule >> rationale [
    ^ 'En Pharo, self s''écrit en minuscules'
]

{ #category : 'accessing' }
ReSelfCapitalizationRule >> severity [
    ^ #error

]
