Class {
	#name : 'ReMissingSuperInitializeRuleTest',
	#superclass : 'ReAbstractRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReMissingSuperInitializeRuleTest >> testDetectMissingSuperInitialize [
    | critiques |
    TestBooleanClass compile: 'initialize
        | x |
        x := 0'.
    critiques := ReMissingSuperInitializeRule new
        checkMethod: (TestBooleanClass >> #initialize).
    TestBooleanClass removeSelector: #initialize.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'super initialize')
]

{ #category : 'tests' }
ReMissingSuperInitializeRuleTest >> testIgnoresOtherMethods [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ 1'.
    critiques := ReMissingSuperInitializeRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty

]

{ #category : 'tests' }
ReMissingSuperInitializeRuleTest >> testNoCritiqueWithSuperInitialize [
    | critiques |
    TestBooleanClass compile: 'initialize
        super initialize'.
    critiques := ReMissingSuperInitializeRule new
        checkMethod: (TestBooleanClass >> #initialize).
    TestBooleanClass removeSelector: #initialize.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReMissingSuperInitializeRuleTest >> testRuleMetadata [
    | rule |
    rule := ReMissingSuperInitializeRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Erreurs intermédiaire'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'MissingSuperInitialize'
]
