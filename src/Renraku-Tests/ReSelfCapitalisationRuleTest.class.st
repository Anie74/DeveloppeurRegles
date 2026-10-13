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

{ #category : 'tests' }
ReSelfCapitalisationRuleTest >> testRuleMetadata [
    | rule |
    rule := ReSelfCapitalizationRule new.
    self assert: rule severity equals: #error.
    self assert: rule group equals: 'Erreurs débutant'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'SelfCapitalization'
]
