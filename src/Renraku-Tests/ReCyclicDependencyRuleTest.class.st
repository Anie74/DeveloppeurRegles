Class {
	#name : 'ReCyclicDependencyRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReCyclicDependencyRuleTest >> testDetectCycleBetweenTwoClasses [
    | critiques |
    TestBooleanClass compile: 'cycle
        ^ TestDataSandbox'.
    TestDataSandbox compile: 'cycle
        ^ TestBooleanClass'.
    critiques := ReCyclicDependencyRule new checkClass: TestBooleanClass.
    TestBooleanClass removeSelector: #cycle.
    TestDataSandbox removeSelector: #cycle.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'TestDataSandbox')
]

{ #category : 'tests' }
ReCyclicDependencyRuleTest >> testNoCritiqueForClassWithoutDependency [
    | critiques |
    TestDataSandbox compile: 'plain
        ^ 1'.
    critiques := ReCyclicDependencyRule new checkClass: TestDataSandbox.
    TestDataSandbox removeSelector: #plain.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReCyclicDependencyRuleTest >> testNoCritiqueForOneWayDependency [
    | critiques |
    TestBooleanClass compile: 'cycle
        ^ TestDataSandbox'.
    critiques := ReCyclicDependencyRule new checkClass: TestBooleanClass.
    TestBooleanClass removeSelector: #cycle.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReCyclicDependencyRuleTest >> testRuleMetadata [
    | rule |
    rule := ReCyclicDependencyRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Architecture'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'CyclicDependency'
]
