"
I represent an abstract class for rules that are meant exclusively for beginners.

My subclasses will only be enabled if the 'Beginners' profile is selected in the settings. To make rules that are meant for beginners and non-beginners you should inherit from other Rule class and overwrite the 'isBeginnerRule' to return true. 
"
Class {
	#name : 'ReExclusivelyBeginnersRule',
	#superclass : 'ReAbstractRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'testing' }
ReExclusivelyBeginnersRule class >> isAbstract [

	 ^ self = ReExclusivelyBeginnersRule
]

{ #category : 'manifest' }
ReExclusivelyBeginnersRule class >> isBeginnerRule [
	^ true
]

{ #category : 'manifest' }
ReExclusivelyBeginnersRule class >> isDefaultRule [

	^ false
]

{ #category : 'testing' }
ReExclusivelyBeginnersRule >> includesWord: aWord in: sourceCode [
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
ReExclusivelyBeginnersRule >> uniqueIdentifierName [
    ^ 'BooleanCapitalization'
]
