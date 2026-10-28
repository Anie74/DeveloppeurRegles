Class {
	#name : 'ExpertFragileTestRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testDetectAssertionOnPrintString [
    | critiques |
    TestSandboxCase compile: 'testText
        self assert: 3 printString equals: 4 printString'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestSandboxCase >> #testText).
    TestSandboxCase removeSelector: #testText.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'printString')
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testDetectClockDependency [
    | critiques |
    TestSandboxCase compile: 'testClock
        self assert: DateAndTime now notNil'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestSandboxCase >> #testClock).
    TestSandboxCase removeSelector: #testClock.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'DateAndTime')
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testDetectRandomDependency [
    | critiques |
    TestSandboxCase compile: 'testRandom
        self assert: Random new next < 2'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestSandboxCase >> #testRandom).
    TestSandboxCase removeSelector: #testRandom.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'Random')
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testDetectReflectiveAccess [
    | critiques |
    TestSandboxCase compile: 'testReflective
        self assert: ((3@4) instVarNamed: #x) equals: 3'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestSandboxCase >> #testReflective).
    TestSandboxCase removeSelector: #testReflective.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'instVarNamed:')
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testDetectSeveralFragilities [
    | critiques |
    TestSandboxCase compile: 'testMany
        self assert: ((3@4) instVarNamed: #x) printString equals: 3 printString'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestSandboxCase >> #testMany).
    TestSandboxCase removeSelector: #testMany.
    self assert: critiques size equals: 2
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testIgnoresClassesThatAreNotTestCases [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ DateAndTime now'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testIgnoresNonTestMethods [
    | critiques |
    TestSandboxCase compile: 'helper
        ^ DateAndTime now'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestSandboxCase >> #helper).
    TestSandboxCase removeSelector: #helper.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testNoCritiqueForRobustTest [
    | critiques |
    TestSandboxCase compile: 'testClean
        self assert: 1 + 1 equals: 2'.
    critiques := ExpertFragileTestRule new
        checkMethod: (TestSandboxCase >> #testClean).
    TestSandboxCase removeSelector: #testClean.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertFragileTestRuleTest >> testRuleMetadata [
    | rule |
    rule := ExpertFragileTestRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Tests'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'FragileTest'
]
