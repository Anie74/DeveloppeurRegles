Class {
	#name : 'IntermediateLevelAnalyzerTest',
	#superclass : 'ReExclusivelyIntermediateRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
IntermediateLevelAnalyzerTest >> testCleanMethodHasNoErrors [
    | analyzer methods |
    TestBooleanClass compile: 'testMethod
        ^ 1'.
    analyzer := IntermediateLevelAnalyzer new.
    methods := { TestBooleanClass >> #testMethod }.
    self assert: (analyzer analyzeMethods: methods) isEmpty.
    self assert: (analyzer levelFor: methods) equals: #expertCandidate
]

{ #category : 'tests' }
IntermediateLevelAnalyzerTest >> testCountsSeveralMethods [
    | counts |
    TestBooleanClass compile: 'testMethod
        | a |
        ^ 1'.
    TestBooleanClass compile: 'otherMethod
        | b |
        ^ 2'.
    counts := IntermediateLevelAnalyzer new
        analyzeMethods: { TestBooleanClass >> #testMethod. TestBooleanClass >> #otherMethod }.
    TestBooleanClass removeSelector: #otherMethod.
    self assert: (counts at: 'UnusedTemporary') equals: 2
]

{ #category : 'tests' }
IntermediateLevelAnalyzerTest >> testIgnoresBeginnerErrors [
    | counts |
    TestBooleanClass compile: 'testMethod
        | unused |
        ^ True'.
    counts := IntermediateLevelAnalyzer new
        analyzeMethods: { TestBooleanClass >> #testMethod }.
    "True (débutant) est ignoré ; seule la variable inutilisée (intermédiaire) est comptée"
    self assert: counts size equals: 1.
    self assert: (counts at: 'UnusedTemporary') equals: 1.
    self deny: (counts includesKey: 'BooleanCapitalization')
]

{ #category : 'tests' }
IntermediateLevelAnalyzerTest >> testLevelAdvancedWhenFewErrors [
    | methods level |
    TestBooleanClass compile: 'testMethod
        | a |
        ^ 1'.
    TestBooleanClass compile: 'otherMethod
        ^ 2'.
    methods := { TestBooleanClass >> #testMethod. TestBooleanClass >> #otherMethod }.
    level := IntermediateLevelAnalyzer new levelFor: methods.
    TestBooleanClass removeSelector: #otherMethod.
    self assert: level equals: #intermediateAdvanced
]

{ #category : 'tests' }
IntermediateLevelAnalyzerTest >> testLevelIntermediateWhenManyErrors [
    | methods |
    TestBooleanClass compile: 'testMethod
        | a b |
        ^ 1'.
    methods := { TestBooleanClass >> #testMethod }.
    self assert: (IntermediateLevelAnalyzer new levelFor: methods) equals: #intermediate

]

{ #category : 'tests' }
IntermediateLevelAnalyzerTest >> testOnlyIntermediateRulesAreLoaded [
    | analyzer |
    analyzer := IntermediateLevelAnalyzer new.
    self assert: analyzer rules size >= 8.
    self assert: (analyzer rules allSatisfy: [ :each |
        each isKindOf: ReExclusivelyIntermediateRule ]).
    self assert: (analyzer rules noneSatisfy: [ :each |
        each isKindOf: ReExclusivelyBeginnersRule ])
]
