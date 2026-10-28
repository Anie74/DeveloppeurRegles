Class {
	#name : 'ExpertPublicMethodDocumentationRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testCustomExemptedProtocols [
    | rule critiques |
    TestBooleanClass compile: 'compute: x
        | a |
        a := x + 1.
        ^ a * 2' classified: 'api'.
    rule := ExpertPublicMethodDocumentationRule new.
    rule exemptedProtocols: #(#api).
    critiques := rule checkMethod: (TestBooleanClass >> #compute:).
    TestBooleanClass removeSelector: #compute:.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testDefaultConvention [
    | rule |
    rule := ExpertPublicMethodDocumentationRule new.
    self assert: rule minimumStatements equals: 2.
    self assert: (rule exemptedProtocols includes: #private)
]

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testDetectUndocumentedPublicMethod [
    | critiques |
    TestBooleanClass compile: 'compute: x
        | a |
        a := x + 1.
        ^ a * 2' classified: 'api'.
    critiques := ExpertPublicMethodDocumentationRule new
        checkMethod: (TestBooleanClass >> #compute:).
    TestBooleanClass removeSelector: #compute:.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'commentaire')
]

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testNoCritiqueWhenDocumented [
    | critiques |
    TestBooleanClass compile: 'compute: x
        "Calcule le double de x plus 2."
        | a |
        a := x + 1.
        ^ a * 2' classified: 'api'.
    critiques := ExpertPublicMethodDocumentationRule new
        checkMethod: (TestBooleanClass >> #compute:).
    TestBooleanClass removeSelector: #compute:.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testPrivateProtocolIsExempt [
    | critiques |
    TestBooleanClass compile: 'compute: x
        | a |
        a := x + 1.
        ^ a * 2' classified: 'private'.
    critiques := ExpertPublicMethodDocumentationRule new
        checkMethod: (TestBooleanClass >> #compute:).
    TestBooleanClass removeSelector: #compute:.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testRuleMetadata [
    | rule |
    rule := ExpertPublicMethodDocumentationRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Maintenance'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'PublicMethodDocumentation'
]

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testShortMethodIsExempt [
    | critiques |
    TestBooleanClass compile: 'compute: x
        ^ x' classified: 'api'.
    critiques := ExpertPublicMethodDocumentationRule new
        checkMethod: (TestBooleanClass >> #compute:).
    TestBooleanClass removeSelector: #compute:.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertPublicMethodDocumentationRuleTest >> testStricterConventionRequiresCommentsOnShortMethods [
    | rule critiques |
    TestBooleanClass compile: 'compute: x
        ^ x' classified: 'api'.
    rule := ExpertPublicMethodDocumentationRule new.
    rule minimumStatements: 1.
    critiques := rule checkMethod: (TestBooleanClass >> #compute:).
    TestBooleanClass removeSelector: #compute:.
    self assert: critiques size equals: 1
]
