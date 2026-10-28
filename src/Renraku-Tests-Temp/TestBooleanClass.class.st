"
Un sandbox
"
Class {
	#name : 'TestBooleanClass',
	#superclass : 'Object',
	#category : 'Renraku-Tests-Temp',
	#package : 'Renraku-Tests-Temp'
}

{ #category : 'as yet unclassified' }
TestBooleanClass >> testMethod [
        | unused |
        ^ True
]

{ #category : 'as yet unclassified' }
TestBooleanClass >> testMethod: x [
        x isString ifTrue: [ ^ 1 ].
        x isNumber ifTrue: [ ^ 2 ].
        x isSymbol ifTrue: [ ^ 3 ].
        ^ 0
]
