Class {
	#name : 'IntermediateLevelAnalyzer',
	#superclass : 'ReExclusivelyIntermediateRule',
	#instVars : [
		'rules'
	],
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'analyzing' }
IntermediateLevelAnalyzer >> analyzeMethods: aCollection [
    "Dictionnaire identifiant de règle -> nombre de critiques.
     Seules les règles intermédiaires sont consultées."
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

{ #category : 'initialization' }
IntermediateLevelAnalyzer >> initialize [
    super initialize.
    "Le filtre inheritsFrom: protège d'une entrée obsolète dans la liste des sous-classes"
    rules := (ReExclusivelyIntermediateRule allSubclasses
        select: [ :each | each inheritsFrom: ReExclusivelyIntermediateRule ])
        collect: [ :each | each new ]
]

{ #category : 'analyzing' }
IntermediateLevelAnalyzer >> levelFor: aCollection [
    "To adjust : more than a critic per method = #intermediate"
    | total density |
    total := self totalIn: aCollection.
    total = 0 ifTrue: [ ^ #expertCandidate ].
    density := total / (aCollection size max: 1).
    density > 1 ifTrue: [ ^ #intermediate ].
    ^ #intermediateAdvanced
]

{ #category : 'accessing' }
IntermediateLevelAnalyzer >> rules [

	^ rules
]

{ #category : 'accessing' }
IntermediateLevelAnalyzer >> rules: anObject [

	rules := anObject
]

{ #category : 'analyzing' }
IntermediateLevelAnalyzer >> totalIn: aCollection [
    ^ (self analyzeMethods: aCollection) values
        inject: 0
        into: [ :sum :each | sum + each ]
]
