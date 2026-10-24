"
Detect boolean comparison with `true` or `false` with `=`, `==`, `~=` ou `~~`.
"
Class {
	#name : 'ReExplicitBooleanComparisonRule',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReExplicitBooleanComparisonRule class >> ruleName [
    ^ 'Explicit Comparaison with true or false'
]

{ #category : 'manifest' }
ReExplicitBooleanComparisonRule class >> uniqueIdentifierName [
    ^ 'ExplicitBooleanComparison'
]

{ #category : 'checking' }
ReExplicitBooleanComparisonRule >> checkMethod: aMethod [
    | critiques |
    critiques := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [ #(#= #== #~= #~~) includes: node selector ])
            ifTrue: [
                ((self isBooleanLiteralNode: node arguments first in: aMethod)
                    or: [ self isBooleanLiteralNode: node receiver in: aMethod ])
                    ifTrue: [
                        critiques add: (self
                            newCritiqueFor: aMethod
                            hint: 'Évitez la comparaison avec true/false : utilisez la valeur booléenne ou not') ] ] ].
    ^ critiques

]

{ #category : 'accessing' }
ReExplicitBooleanComparisonRule >> group [
    ^ 'Errors for intermediate'


]

{ #category : 'accessing' }
ReExplicitBooleanComparisonRule >> name [
    ^ 'Explicit Comparaison with true or false'

]

{ #category : 'accessing' }
ReExplicitBooleanComparisonRule >> rationale [
    ^ 'Use directly boolean values (or not) instead of comparing with true or false'


]

{ #category : 'accessing' }
ReExplicitBooleanComparisonRule >> severity [
    ^ #warning
]
