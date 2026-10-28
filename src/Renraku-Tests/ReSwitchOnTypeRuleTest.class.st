Class {
	#name : 'ReSwitchOnTypeRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReSwitchOnTypeRuleTest >> testDetectMixedTypeTests [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        x isString ifTrue: [ ^ 1 ].
        x isNumber ifTrue: [ ^ 2 ].
        x isSymbol ifTrue: [ ^ 3 ].
        ^ 0'.
    critiques := ReSwitchOnTypeRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1
]

{ #category : 'tests' }
ReSwitchOnTypeRuleTest >> testDetectThreeIsKindOf [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        (x isKindOf: String) ifTrue: [ ^ 1 ].
        (x isKindOf: Number) ifTrue: [ ^ 2 ].
        (x isKindOf: Array) ifTrue: [ ^ 3 ].
        ^ 0'.
    critiques := ReSwitchOnTypeRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'polymorphisme')
]

{ #category : 'tests' }
ReSwitchOnTypeRuleTest >> testNoCritiqueForTwoTypeTests [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        x isString ifTrue: [ ^ 1 ].
        x isNumber ifTrue: [ ^ 2 ].
        ^ 0'.
    critiques := ReSwitchOnTypeRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReSwitchOnTypeRuleTest >> testNoCritiqueWithoutTypeTests [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        ^ x printString'.
    critiques := ReSwitchOnTypeRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReSwitchOnTypeRuleTest >> testRuleMetadata [
    | rule |
    rule := ReSwitchOnTypeRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Conception avancée'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'SwitchOnType'
]
