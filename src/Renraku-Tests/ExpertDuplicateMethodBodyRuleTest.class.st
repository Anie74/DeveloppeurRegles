Class {
	#name : 'ExpertDuplicateMethodBodyRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ExpertDuplicateMethodBodyRuleTest >> testDetectDuplicatesWithDifferentVariableNames [
    | critiques |
    TestDataSandbox compile: 'first: x
        | a |
        a := x + 1.
        ^ a * 2'.
    TestDataSandbox compile: 'second: y
        | b |
        b := y + 1.
        ^ b * 2'.
    critiques := ExpertDuplicateMethodBodyRule new checkClass: TestDataSandbox.
    TestDataSandbox removeSelector: #first:.
    TestDataSandbox removeSelector: #second:.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'first:').
    self assert: (critiques first tinyHint includesSubstring: 'second:')
]

{ #category : 'tests' }
ExpertDuplicateMethodBodyRuleTest >> testNoCritiqueForDifferentBodies [
    | critiques |
    TestDataSandbox compile: 'first: x
        | a |
        a := x + 1.
        ^ a * 2'.
    TestDataSandbox compile: 'second: y
        | b |
        b := y + 1.
        ^ b * 3'.
    critiques := ExpertDuplicateMethodBodyRule new checkClass: TestDataSandbox.
    TestDataSandbox removeSelector: #first:.
    TestDataSandbox removeSelector: #second:.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertDuplicateMethodBodyRuleTest >> testNoCritiqueForTrivialMethods [
    | critiques |
    TestDataSandbox compile: 'one
        ^ 1'.
    TestDataSandbox compile: 'two
        ^ 1'.
    critiques := ExpertDuplicateMethodBodyRule new checkClass: TestDataSandbox.
    TestDataSandbox removeSelector: #one.
    TestDataSandbox removeSelector: #two.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertDuplicateMethodBodyRuleTest >> testNoCritiqueWhenArityDiffers [
    | critiques |
    TestDataSandbox compile: 'first: x
        | a |
        a := 1 + 1.
        ^ a * 2'.
    TestDataSandbox compile: 'second
        | b |
        b := 1 + 1.
        ^ b * 2'.
    critiques := ExpertDuplicateMethodBodyRule new checkClass: TestDataSandbox.
    TestDataSandbox removeSelector: #first:.
    TestDataSandbox removeSelector: #second.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertDuplicateMethodBodyRuleTest >> testRuleMetadata [
    | rule |
    rule := ExpertDuplicateMethodBodyRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Maintenance'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'DuplicateMethodBody'
]

{ #category : 'tests' }
ExpertDuplicateMethodBodyRuleTest >> testSameFingerprintForRenamedVariables [
    | rule one two |
    TestDataSandbox compile: 'first: x
        | a |
        a := x + 1.
        ^ a * 2'.
    TestDataSandbox compile: 'second: y
        | b |
        b := y + 1.
        ^ b * 2'.
    rule := ExpertDuplicateMethodBodyRule new.
    one := rule fingerprintOfMethod: (TestDataSandbox >> #first:).
    two := rule fingerprintOfMethod: (TestDataSandbox >> #second:).
    TestDataSandbox removeSelector: #first:.
    TestDataSandbox removeSelector: #second:.
    self assert: one equals: two
]
