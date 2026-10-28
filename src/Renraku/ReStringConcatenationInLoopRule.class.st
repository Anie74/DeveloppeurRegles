Class {
	#name : 'ReStringConcatenationInLoopRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReStringConcatenationInLoopRule class >> ruleName [
    ^ 'Concaténation de chaînes dans une boucle'
]

{ #category : 'manifest' }
ReStringConcatenationInLoopRule class >> uniqueIdentifierName [
    ^ 'StringConcatenationInLoop'
]

{ #category : 'checking' }
ReStringConcatenationInLoopRule >> checkMethod: aMethod [
    | critiques |
    critiques := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isAssignment and: [
            node value isMessage and: [
                node value selector = #, and: [
                    node value receiver isVariable and: [
                        node value receiver name = node variable name ] ] ] ])
            ifTrue: [
                (self isInsideIterationBlock: node) ifTrue: [
                    critiques add: (self
                        newCritiqueFor: aMethod
                        hint: 'Concaténation de ', node variable name,
                            ' dans une boucle : utilisez un WriteStream') ] ] ].
    ^ critiques
]

{ #category : 'accessing' }
ReStringConcatenationInLoopRule >> group [
    ^ 'Performance'
]

{ #category : 'private' }
ReStringConcatenationInLoopRule >> isInsideIterationBlock: aNode [
    | current |
    current := aNode parent.
    [ current notNil ] whileTrue: [
        (current isBlock and: [
            current parent notNil and: [
                current parent isMessage and: [
                    self iterationSelectors includes: current parent selector ] ] ])
            ifTrue: [ ^ true ].
        current := current parent ].
    ^ false
]

{ #category : 'accessing' }
ReStringConcatenationInLoopRule >> iterationSelectors [
    ^ #(#do: #collect: #select: #reject: #detect: #inject:into: #timesRepeat:
        #to:do: #do:separatedBy: #keysAndValuesDo: #reverseDo: #with:do:)
]

{ #category : 'accessing' }
ReStringConcatenationInLoopRule >> name [
    ^ 'Concaténation de chaînes dans une boucle'
]

{ #category : 'accessing' }
ReStringConcatenationInLoopRule >> rationale [
    ^ 'Concaténer avec une virgule dans une boucle recopie la chaîne à chaque tour : utilisez un WriteStream'
]

{ #category : 'accessing' }
ReStringConcatenationInLoopRule >> severity [
    ^ #warning
]
