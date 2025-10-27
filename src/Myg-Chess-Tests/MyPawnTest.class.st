Class {
	#name : 'MyPawnTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyPawnTest >> testPawnAdvancesOneSquare [ [
	" Avancée simple d'une case vers l'avant"
	| game pawn |
	game := MyChessGame freshGame.
	pawn := game pieces detect: [ :p | p class = MyPawn and: [ p square name = 'e2' ] ].
	
	game move: pawn to: pawn square up.
	
	self assert: pawn square name equals: 'e3'.
	self deny: (game board at: 'e2') hasPiece.
]
]

{ #category : 'tests' }
MyPawnTest >> testPawnBlockedCannotMove [ [
	| game whitePawn blackPawn  initialSquare |
	game := MyChessGame freshGame.
	whitePawn := game pieces detect: [ :p | p class = MyPawn and: [ p square name = 'e2' ] ].
	blackPawn := game pieces detect: [ :p | p class = MyPawn and: [ p square name = 'e7' ] ].
	
	"Déplacer les pions pour qu'ils se bloquent"
	game move: whitePawn to: whitePawn square up up.
	game play.
	game move: blackPawn to: blackPawn square down down.
	game play.
	
	"Essayer d'avancer le pion blanc, il doit être bloqué"
	
	initialSquare := whitePawn square.
	game move: whitePawn to: whitePawn square up.
	
	self assert: whitePawn square equals: initialSquare.
]
]

{ #category : 'tests' }
MyPawnTest >> testPawnCanMakeInitialDoubleMove [ [
	| game pawn |
	game := MyChessGame freshGame.
	pawn := game pieces detect: [ :p | p class = MyPawn and: [ p square name = 'a2' ] ].
	
	game move: pawn to: (pawn square up up).
	
	self assert: pawn square name equals: 'a4'.
	self deny: (game board at: 'a2') hasPiece.
]
]

{ #category : 'tests' }
MyPawnTest >> testPawnCannotJumpOverObstacleForDoubleMove [ [
	"le pion ne peut pas sauter par-dessus une pièce pour le double mouvement"

	| game pawn obstacle  initialSquare |
	game := MyChessGame freshGame.
	pawn := game pieces detect: [ :p | p class = MyPawn and: [ p square name = 'b2' ] ] .
	obstacle := game pieces detect: [ :p | p class = MyPawn and: [ p square name = 'b7' ] ].
	
	"Déplacer l'obstacle sur b3 pour bloquer le chemin"
	game move: obstacle to: obstacle square down down.
	game move: obstacle to: obstacle square down.
	game move: obstacle to: obstacle square down.
	
	"Le pion sur b2 ne peut pas faire de double mouvement mais peut avancer d'une cas"
	initialSquare := pawn square.
	game move: pawn to: (pawn square up up).
	
	"Le double mouvement doit échouer, seul b3 doit être accessible"
	self deny: pawn square name equals: 'b4'.
	self assert: pawn square name equals: 'b3'.
]
]
