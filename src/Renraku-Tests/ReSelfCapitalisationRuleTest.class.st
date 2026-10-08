Class {
	#name : 'ReSelfCapitalisationRuleTest',
	#superclass : 'ReExclusivelyBeginnersRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReSelfCapitalisationRuleTest >> testDetectSelf [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | Self |
        ^ Self'.
    critiques := ReSelfCapitalizationRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'self')

]

{ #category : 'tests' }
ReSelfCapitalisationRuleTest >> testIgnoresLongerIdentifiers [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | SelfishValue |
        ^ SelfishValue'.
    critiques := ReSelfCapitalizationRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReSelfCapitalisationRuleTest >> testNoFalsePositives [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ self printString'.
    critiques := ReSelfCapitalizationRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]
