Class {
	#name : 'ExpertPackageDependencyRule',
	#superclass : 'ReExclusivelyExpertRule',
	#instVars : [
		'packagePrefix',
		'dependencyCache'
	],
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ExpertPackageDependencyRule class >> ruleName [
    ^ 'Dépendances cycliques entre packages'
]

{ #category : 'manifest' }
ExpertPackageDependencyRule class >> uniqueIdentifierName [
    ^ 'PackageDependency'
]

{ #category : 'checking' }
ExpertPackageDependencyRule >> checkPackage: aPackageName [
    | cycle |
    cycle := self
        cycleFrom: aPackageName
        using: [ :each | self dependenciesOfPackageNamed: each ].
    cycle isEmpty ifTrue: [ ^ #() ].
    ^ { self
        newCritiqueFor: aPackageName
        hint: 'Dépendance cyclique entre packages : ', (' -> ' join: cycle) }
]

{ #category : 'dependencies' }
ExpertPackageDependencyRule >> computeDependenciesOfPackageNamed: aName [
    | package found |
    package := PackageOrganizer default packageNamed: aName ifAbsent: [ nil ].
    package isNil ifTrue: [ ^ #() ].
    found := Set new.
    package definedClasses do: [ :aClass |
        (aClass methods , aClass class methods) do: [ :method |
            method ast nodesDo: [ :node |
                | global |
                (node isVariable and: [ node name first isUppercase ]) ifTrue: [
                    global := Smalltalk at: node name asSymbol ifAbsent: [ nil ].
                    global isClass
                        ifTrue: [ found add: global package name asString ] ] ] ] ].
    ^ (found reject: [ :each |
            each = aName or: [
                packagePrefix isEmpty not and: [ (each beginsWith: packagePrefix) not ] ] ])
        asOrderedCollection
]

{ #category : 'cycles' }
ExpertPackageDependencyRule >> cycleFrom: aStartName using: aDependencyBlock [
    "Chemin du cycle qui passe par aStartName (ex: A B A), ou une collection vide"
    ^ self
        search: aStartName
        target: aStartName
        path: (OrderedCollection with: aStartName)
        visited: Set new
        using: aDependencyBlock
]

{ #category : 'dependencies' }
ExpertPackageDependencyRule >> dependenciesOfPackageNamed: aName [
    ^ dependencyCache
        at: aName
        ifAbsentPut: [ self computeDependenciesOfPackageNamed: aName ]
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> dependencyCache [
    ^ dependencyCache
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> group [
    ^ 'Architecture'
]

{ #category : 'initialization' }
ExpertPackageDependencyRule >> initialize [
    super initialize.
    packagePrefix := ''.
    dependencyCache := Dictionary new
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> name [
    ^ 'Dépendances cycliques entre packages'
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> packagePrefix [
    ^ packagePrefix
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> packagePrefix: aString [
    packagePrefix := aString
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> rationale [
    ^ 'Deux packages qui dépendent l''un de l''autre, même indirectement, ne peuvent pas être chargés ni testés séparément'
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> resetCache [
    dependencyCache := Dictionary new
]

{ #category : 'cycles' }
ExpertPackageDependencyRule >> search: aName target: aTarget path: aPath visited: aVisited using: aBlock [
    | found |
    (aBlock value: aName) do: [ :next |
        next = aTarget ifTrue: [ ^ aPath copyWith: aTarget ].
        (aVisited includes: next) ifFalse: [
            aVisited add: next.
            found := self
                search: next
                target: aTarget
                path: (aPath copyWith: next)
                visited: aVisited
                using: aBlock.
            found isEmpty ifFalse: [ ^ found ] ] ].
    ^ #()
]

{ #category : 'accessing' }
ExpertPackageDependencyRule >> severity [
    ^ #warning
]
