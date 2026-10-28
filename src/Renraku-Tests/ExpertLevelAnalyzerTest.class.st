Class {
	#name : 'ExpertLevelAnalyzerTest',
	#superclass : 'TestCase',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testAnalyzeClassIncludesClassLevelRules [
    | counts |
    TestBooleanClass compile: 'cycle
        ^ TestDataSandbox'.
    TestDataSandbox compile: 'cycle
        ^ TestBooleanClass'.
    counts := ExpertLevelAnalyzer new analyzeClass: TestBooleanClass.
    TestBooleanClass removeSelector: #cycle.
    TestDataSandbox removeSelector: #cycle.
    self assert: (counts at: 'CyclicDependency') equals: 1
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testAnalyzePackageReturnsADictionary [
    | analyzer |
    analyzer := ExpertLevelAnalyzer new.
    (analyzer rules detect: [ :each | each isKindOf: ExpertPackageDependencyRule ])
        packagePrefix: 'Renraku'.
    self assert: (analyzer analyzePackageNamed: 'Renraku-Tests-Temp') isDictionary
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testAnalyzeUnknownPackageIsEmpty [
    self assert: (ExpertLevelAnalyzer new analyzePackageNamed: 'NoSuchPackageForTests') isEmpty
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testCountsExpertErrors [
    | counts |
    TestBooleanClass compile: 'first: a second: b third: c fourth: d fifth: e
        ^ a'.
    counts := ExpertLevelAnalyzer new
        analyzeMethods: { TestBooleanClass >> #first:second:third:fourth:fifth: }.
    TestBooleanClass removeSelector: #first:second:third:fourth:fifth:.
    self assert: (counts at: 'LongParameterList') equals: 1.
    self assert: counts size equals: 1
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testIgnoresBeginnerAndIntermediateErrors [
    | analyzer methods |
    "True = erreur débutant ; variable inutilisée = erreur intermédiaire"
    TestBooleanClass compile: 'testMethod
        | unused |
        ^ True'.
    analyzer := ExpertLevelAnalyzer new.
    methods := { TestBooleanClass >> #testMethod }.
    self assert: (analyzer analyzeMethods: methods) isEmpty.
    self assert: (analyzer levelFor: methods) equals: #expert
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testLevelExpertCandidateWithOneError [
    | methods level |
    TestBooleanClass compile: 'first: a second: b third: c fourth: d fifth: e
        ^ a'.
    methods := { TestBooleanClass >> #first:second:third:fourth:fifth: }.
    level := ExpertLevelAnalyzer new levelFor: methods.
    TestBooleanClass removeSelector: #first:second:third:fourth:fifth:.
    self assert: level equals: #expertCandidate
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testLevelIntermediateAdvancedWithManyErrors [
    | methods level |
    "5 paramètres + 4 niveaux d'imbrication = 2 critiques pour 1 méthode"
    TestBooleanClass compile: 'first: a second: b third: c fourth: d fifth: e
        a > 0 ifTrue: [
            a > 1 ifTrue: [
                a > 2 ifTrue: [
                    a > 3 ifTrue: [ ^ 1 ] ] ] ].
        ^ 0'.
    methods := { TestBooleanClass >> #first:second:third:fourth:fifth: }.
    level := ExpertLevelAnalyzer new levelFor: methods.
    TestBooleanClass removeSelector: #first:second:third:fourth:fifth:.
    self assert: level equals: #intermediateAdvanced
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testNewRulesAreLoaded [
    | analyzer |
    analyzer := ExpertLevelAnalyzer new.
    self assert: analyzer rules size >= 14
]

{ #category : 'tests' }
ExpertLevelAnalyzerTest >> testOnlyExpertRulesAreLoaded [
    | analyzer |
    analyzer := ExpertLevelAnalyzer new.
    self assert: analyzer rules size >= 9.
    self assert: (analyzer rules allSatisfy: [ :each |
        each isKindOf: ReExclusivelyExpertRule ]).
    self assert: (analyzer rules noneSatisfy: [ :each |
        each isKindOf: ReExclusivelyBeginnersRule ]).
    self assert: (analyzer rules noneSatisfy: [ :each |
        each isKindOf: ReExclusivelyIntermediateRule ])
]
