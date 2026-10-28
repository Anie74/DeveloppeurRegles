Class {
	#name : 'ReCyclicDependencyRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReCyclicDependencyRule class >> ruleName [
    ^ 'Dépendance cyclique entre classes'
]

{ #category : 'manifest' }
ReCyclicDependencyRule class >> uniqueIdentifierName [
    ^ 'CyclicDependency'
]

{ #category : 'checking' }
ReCyclicDependencyRule >> checkClass: aClass [
    ^ ((self referencedClassesOf: aClass) select: [ :other |
            self does: other reference: aClass ])
        asOrderedCollection
        collect: [ :other |
            self
                newCritiqueFor: aClass
                hint: 'Dépendance cyclique avec ', other name asString ]
]

{ #category : 'private' }
ReCyclicDependencyRule >> does: aSourceClass reference: aTargetClass [
    "Pré-filtre sur le texte, puis confirmation sur l'AST : évite d'analyser
     toutes les méthodes de grandes classes comme Object ou String"
    | targetName |
    targetName := aTargetClass name asString.
    ^ aSourceClass methods anySatisfy: [ :method |
        (method sourceCode includesSubstring: targetName)
            and: [ self isMethod: method referencing: targetName ] ]
]

{ #category : 'accessing' }
ReCyclicDependencyRule >> group [
    ^ 'Architecture'
]

{ #category : 'private' }
ReCyclicDependencyRule >> isMethod: aMethod referencing: aName [
    aMethod ast nodesDo: [ :node |
        (node isVariable and: [ node name = aName ]) ifTrue: [ ^ true ] ].
    ^ false
]

{ #category : 'accessing' }
ReCyclicDependencyRule >> name [
    ^ 'Dépendance cyclique entre classes'
]

{ #category : 'accessing' }
ReCyclicDependencyRule >> rationale [
    ^ 'Deux classes qui se référencent mutuellement sont fortement couplées et difficiles à réutiliser séparément'
]

{ #category : 'private' }
ReCyclicDependencyRule >> referencedClassesOf: aClass [
    | found |
    found := Set new.
    aClass methods do: [ :method |
        method ast nodesDo: [ :node |
            | global |
            (node isVariable and: [ node name first isUppercase ]) ifTrue: [
                global := Smalltalk at: node name asSymbol ifAbsent: [ nil ].
                (global isClass and: [ global ~~ aClass ])
                    ifTrue: [ found add: global ] ] ] ].
    ^ found
]

{ #category : 'accessing' }
ReCyclicDependencyRule >> severity [
    ^ #warning
]
