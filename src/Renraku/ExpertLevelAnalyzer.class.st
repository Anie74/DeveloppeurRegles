Class {
	#name : 'ExpertLevelAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'rules'
	],
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'analysis' }
ExpertLevelAnalyzer >> analyzeClass: aClass [
    | counts |
    counts := self analyzeMethods: aClass methods.
    rules do: [ :rule |
        | found key |
        found := (rule checkClass: aClass) size.
        key := rule class uniqueIdentifierName.
        found > 0 ifTrue: [
            counts at: key put: (counts at: key ifAbsent: [ 0 ]) + found ] ].
    ^ counts
]

{ #category : 'analysis' }
ExpertLevelAnalyzer >> analyzeMethods: aCollection [
    "Dictionnaire identifiant de règle -> nombre de critiques.
     Seules les règles expertes sont consultées."
    | counts |
    counts := Dictionary new.
    aCollection do: [ :method |
        rules do: [ :rule |
            | found key |
            found := (rule checkMethod: method) size.
            key := rule class uniqueIdentifierName.
            found > 0 ifTrue: [
                counts at: key put: (counts at: key ifAbsent: [ 0 ]) + found ] ] ].
    ^ counts
]

{ #category : 'analysis' }
ExpertLevelAnalyzer >> analyzePackageNamed: aPackageName [
    | package counts |
    counts := Dictionary new.
    package := PackageOrganizer default packageNamed: aPackageName ifAbsent: [ nil ].
    package isNil ifTrue: [ ^ counts ].
    package definedClasses do: [ :aClass |
        (self analyzeClass: aClass) keysAndValuesDo: [ :key :value |
            counts at: key put: (counts at: key ifAbsent: [ 0 ]) + value ] ].
    rules do: [ :rule |
        | found key |
        found := (rule checkPackage: aPackageName) size.
        key := rule class uniqueIdentifierName.
        found > 0 ifTrue: [
            counts at: key put: (counts at: key ifAbsent: [ 0 ]) + found ] ].
    ^ counts
]

{ #category : 'initialization' }
ExpertLevelAnalyzer >> initialize [
    super initialize.
    "Le filtre inheritsFrom: protège d'une entrée obsolète dans la liste des sous-classes"
    rules := (ReExclusivelyExpertRule allSubclasses
        select: [ :each | each inheritsFrom: ReExclusivelyExpertRule ])
        collect: [ :each | each new ]
]

{ #category : 'analysis' }
ExpertLevelAnalyzer >> levelFor: aCollection [
    "Seuils à ajuster :
     aucun défaut de conception = #expert,
     au plus 1 défaut par méthode en moyenne = #expertCandidate,
     davantage = #intermediateAdvanced"
    | total density |
    total := self totalIn: aCollection.
    total = 0 ifTrue: [ ^ #expert ].
    density := total / (aCollection size max: 1).
    density > 1 ifTrue: [ ^ #intermediateAdvanced ].
    ^ #expertCandidate
]

{ #category : 'accessing' }
ExpertLevelAnalyzer >> rules [
    ^ rules
]

{ #category : 'analysis' }
ExpertLevelAnalyzer >> totalIn: aCollection [
    ^ (self analyzeMethods: aCollection) values
        inject: 0
        into: [ :sum :each | sum + each ]
]
