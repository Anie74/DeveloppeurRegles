Class {
	#name : 'ExpertPackageDependencyRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testCritiqueNamesTheCycle [
    | rule critiques |
    rule := ExpertPackageDependencyRule new.
    rule dependencyCache
        at: 'A' put: #('B');
        at: 'B' put: #('A').
    critiques := rule checkPackage: 'A'.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'A -> B -> A')
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testCycleNotThroughTheStartIsIgnored [
    | graph cycle |
    "B et C forment un cycle, mais A n'en fait pas partie"
    graph := Dictionary newFrom: { 'A' -> #('B'). 'B' -> #('C'). 'C' -> #('B') }.
    cycle := ExpertPackageDependencyRule new
        cycleFrom: 'A'
        using: [ :each | graph at: each ifAbsent: [ #() ] ].
    self assert: cycle isEmpty
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testDetectDirectCycle [
    | graph cycle |
    graph := Dictionary newFrom: { 'A' -> #('B'). 'B' -> #('A') }.
    cycle := ExpertPackageDependencyRule new
        cycleFrom: 'A'
        using: [ :each | graph at: each ifAbsent: [ #() ] ].
    self assert: cycle asArray equals: #('A' 'B' 'A')
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testDetectIndirectCycle [
    | graph cycle |
    graph := Dictionary newFrom: { 'A' -> #('B'). 'B' -> #('C'). 'C' -> #('A') }.
    cycle := ExpertPackageDependencyRule new
        cycleFrom: 'A'
        using: [ :each | graph at: each ifAbsent: [ #() ] ].
    self assert: cycle asArray equals: #('A' 'B' 'C' 'A')
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testNoCritiqueWithoutCycle [
    | rule |
    rule := ExpertPackageDependencyRule new.
    rule dependencyCache
        at: 'A' put: #('B');
        at: 'B' put: #().
    self assert: (rule checkPackage: 'A') isEmpty
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testNoCycle [
    | graph cycle |
    graph := Dictionary newFrom: { 'A' -> #('B'). 'B' -> #('C') }.
    cycle := ExpertPackageDependencyRule new
        cycleFrom: 'A'
        using: [ :each | graph at: each ifAbsent: [ #() ] ].
    self assert: cycle isEmpty
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testRuleMetadata [
    | rule |
    rule := ExpertPackageDependencyRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Architecture'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'PackageDependency'
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testSandboxClassBelongsToItsPackage [
    self assert: TestBooleanClass package name asString equals: 'Renraku-Tests-Temp'
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testSandboxPackageHasNoDependencyInsideItself [
    | rule |
    rule := ExpertPackageDependencyRule new.
    rule packagePrefix: 'Renraku'.
    self assert: (rule dependenciesOfPackageNamed: 'Renraku-Tests-Temp') isEmpty
]

{ #category : 'tests' }
ExpertPackageDependencyRuleTest >> testUnknownPackageHasNoDependencies [
    | rule |
    rule := ExpertPackageDependencyRule new.
    self assert: (rule dependenciesOfPackageNamed: 'NoSuchPackageForTests') isEmpty
]
