"
Rules for Expert
"
Class {
	#name : 'ReExclusivelyExpertRule',
	#superclass : 'ReAbstractRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'testing' }
ReExclusivelyExpertRule class >> isAbstract [
    ^ self == ReExclusivelyExpertRule
]

{ #category : 'accessing' }
ReExclusivelyExpertRule class >> ruleName [
    ^ 'Règles de niveau expert (classe abstraite)'
]

{ #category : 'checking' }
ReExclusivelyExpertRule >> checkClass: aClass [
    ^ #()
]

{ #category : 'checking' }
ReExclusivelyExpertRule >> checkMethod: aMethod [
    ^ #()
]

{ #category : 'checking' }
ReExclusivelyExpertRule >> checkPackage: aPackageName [
    ^ #()
]

{ #category : 'private' }
ReExclusivelyExpertRule >> newCritiqueFor: anEntity hint: aString [
    ^ (ReTrivialCritique for: anEntity by: self)
        tinyHint: aString;
        yourself
]
