# Module for matrices
Matrices<public> := module:
 
	using { Arrays }
	using { Comparisons }
	using { /UnrealEngine.com/Temporary }
 
	# Float Matrices
	Matrix<public> := class<concrete>:
		Rows<public>:int=0
		Cols<public>:int=0
		Rep<public>:[][]float=array{}
	<# MATRIX CONSTRUCTION #>
 
	# Construct matrix
	ConstructMatrix<public><constructor>(InRep:[][]float)<decides><transacts>:=Matrix:
		let:
			var InRows:int = InRep.Length
			var InCols:int = if (ColOne:=InRep[0].Length, ColOne > 0):
				ColOne
			else:
				0
		block:
			for (Row:=0..InRows-1):
				InRep[Row].Length = InCols
		Rows:=InRows
		Cols:=InCols
		Rep:=InRep
	# Construct matrix from integers
	ConstructMatrixFromInts<public><constructor>(InRep:[][]int)<decides><transacts>:=Matrix:
		let:
			var InRows:int = InRep.Length
			var RepTemp:[][]float = array{}
			var InCols:int = if (ColOne:=InRep[0].Length, ColOne > 0):
				ColOne
			else:
				0
		block:
			for (Row:=0..InRows-1):
				InRep[Row].Length = InCols
			for (Row:=0..InRows-1):
				if:
					TempRow := for(Col:=0..InCols-1):
						1.0*InRep[Row][Col]
					set RepTemp += array{TempRow}
		Rows:=InRows
		Cols:=InCols
		Rep:=RepTemp
	# Create copy of matrix
	(InMatrix:Matrix).Copy<public>()<transacts>:Matrix=
		Matrix:
			Rows:=InMatrix.Rows
			Cols:=InMatrix.Cols
			Rep:=InMatrix.Rep
	# Identity matrix
	Identity<public>(Size:int)<transacts>:Matrix=
		var RepTemp:[][]float = array{}
		for (Row:=0..Size-1):
			TempRow:[]float = for(Col:=0..Size-1):
				if (Row = Col):
					1.0
				else:
					0.0
			set RepTemp += array{TempRow}
		Matrix:
			Rows:=Size
			Cols:=Size
			Rep:=RepTemp

	# Zero matrix
	Zeros<public>(InRows:int, InCols:int)<transacts>:Matrix=
		var RepTemp:[][]float = array{}
		for (Row:=0..InRows-1):
			TempRow:[]float = for(Col:=0..InCols-1):
				0.0
			set RepTemp += array{TempRow}
		Matrix:
			Rows:=InRows
			Cols:=InCols
			Rep:=RepTemp

	# Square zero matrix
	Zeros<public>(Size:int)<transacts>:Matrix=
		Zeros(Size, Size)

	# Matrix with ones on main diagonal
	MainDiagonalOnes<public>(InRows:int, InCols:int)<transacts>:Matrix=
		var RepTemp:[][]float = array{}
		for (Row:=0..InRows-1):
			TempRow:[]float = for(Col:=0..InCols-1):
				if (Row = Col):
					1.0
				else:
					0.0
			set RepTemp += array{TempRow}
		Matrix:
			Rows:=InRows
			Cols:=InCols
			Rep:=RepTemp

	<# MATRIX OPERATIONS #>
 
	# Summary: Multiply two float matrices
	# Complexity: Theta(n^3)
	operator'*'<public>(InMatrixOne:Matrix, InMatrixTwo:Matrix)<transacts><decides>:Matrix=
		InMatrixOne.Cols = InMatrixTwo.Rows
		var ResultMatrix:Matrix = Zeros(InMatrixOne.Rows,InMatrixTwo.Cols)
		for (Row:=0..InMatrixOne.Rows-1):
			for (Col:=0..InMatrixTwo.Cols-1):
				var RowColEntry:float = 0.0
				for (MatchDimension:=0..InMatrixOne.Cols-1):
					set RowColEntry += (InMatrixOne.Rep[Row][MatchDimension] * InMatrixTwo.Rep[MatchDimension][Col])
				ResultMatrixTemp := ResultMatrix.SetElementAtIndex[(Row,Col), RowColEntry]
				set ResultMatrix = ResultMatrixTemp
		ResultMatrix

	# Summary: Add two float matrices
	# Complexity: Theta(n^2)
	operator'+'<public>(InMatrixOne:Matrix, InMatrixTwo:Matrix)<transacts><decides>:Matrix=
		InMatrixOne.Cols = InMatrixTwo.Cols
		InMatrixOne.Rows = InMatrixTwo.Rows
		var TempRep:[][]float = array{}
		for (Row:=0..InMatrixOne.Rows-1):
			if:
				TempRow := for(Col:=0..InMatrixOne.Cols-1):
					InMatrixOne.Rep[Row][Col] + InMatrixTwo.Rep[Row][Col]
				set TempRep += array{TempRow}
		ConstructMatrix[TempRep]

	# Summary: Subtract two float matrices
	# Complexity: Theta(n^2)
	operator'-'<public>(InMatrixOne:Matrix, InMatrixTwo:Matrix)<transacts><decides>:Matrix=
		InMatrixOne.Cols = InMatrixTwo.Cols
		InMatrixOne.Rows = InMatrixTwo.Rows
		var TempRep:[][]float = array{}
		for (Row:=0..InMatrixOne.Rows-1):
			if:
				TempRow := for(Col:=0..InMatrixOne.Cols-1):
					InMatrixOne.Rep[Row][Col] - InMatrixTwo.Rep[Row][Col]
				set TempRep += array{TempRow}
		ConstructMatrix[TempRep]

	# Summary: Transpose a matrix
	# 		Converts a n x m matrix into an m x n matrix by reflecting over main diagonal
	# Complexity: Theta(n^2)
	(InMatrix:Matrix).Transpose<public>()<decides><transacts>:Matrix=
		var NewRep:[][]float = array{}
		for (Col:=0..InMatrix.Cols-1):
			if:
				TempRow := for(Row:=0..InMatrix.Rows-1):
					InMatrix.Rep[Row][Col]
				set NewRep += array{TempRow}
		ConstructMatrix[NewRep]

	# Summary: Invert a matrix
	#		Find a matrix B such that AB = I, if one exists
	# Complexity: Theta(n^3)
	(InMatrix:Matrix).Inverse<public>()<decides><transacts>:Matrix=
		var Columns:[][]float = array{}
		InMatrix.Rows = InMatrix.Cols
		Size:int = InMatrix.Rows
		LUPDecomposition := LUP[InMatrix]
		LowerTriangular:Matrix = LUPDecomposition(0)
		UpperTriangular:Matrix = LUPDecomposition(1)
		PermutationArray:[]int = LUPDecomposition(2)
		for (Row:=0..Size-1):
			ResultantVector:[]float = for (Col:=0..Size-1):
				if (Row = Col):
					1.0
				else:
					0.0
			LinearSystemSolution := LUPSolve(LowerTriangular, UpperTriangular, PermutationArray, ResultantVector)
			set Columns += array{LinearSystemSolution}
		OutMatrix:Matrix = ConstructMatrix[Columns]
		OutMatrix.Transpose[]

	# Summary: Determinant of a matrix
	# Complexity: Theta(n^3)
	(InMatrix:Matrix).Determinant<public>()<decides><transacts>:float=
		if (LUPDecomposition := LUP[InMatrix]):
			UpperTriangular:=LUPDecomposition(1)
			Diagonal:[]float = for (i:=0..UpperTriangular.Rows-1):
				UpperTriangular.GetElementAtIndex[i,i]
			var AccumulatedProduct:float = 1.0
			for (Element:Diagonal):
				set AccumulatedProduct *= Element
			AccumulatedProduct
		else:
			0.0

	# Summary: Set the value of the matrix at the specified tuple index
	# Theta(n^2)
	(InMatrix:Matrix).SetElementAtIndex<public>(Index:tuple(int,int), Element:float)<decides><transacts>:Matrix=
		var TempRep:[][]float = array{}
		var Success:logic = true
		for (Row:=0..InMatrix.Rows-1):
			TempRow:[]float = for(Col:=0..InMatrix.Cols-1):
				if (Row = Index(0), Col = Index(1)):
					Element
				else if (InEntry := InMatrix.Rep[Row][Col]):
					InEntry
				else:
					set Success = false
					0.0
			set TempRep += array{TempRow}
		Success?
		ConstructMatrix[TempRep]

	# Complexity: Theta(n^2)
	(InMatrix:Matrix).GetElementAtIndex<public>(Row:int, Col:int)<decides><transacts>:float=
		InMatrix.Rep[Row][Col]

	<# MATRIX ALGORITHMS #>
 
	# Solve a system of linear equations of the form Ax = b for the vector x
	SolveLinearSystem<public>(A:Matrix, b:[]float)<decides><transacts>:[]float =
		LUPDecomposition := LUP[A]
		LowerTriangular:Matrix = LUPDecomposition(0)
		UpperTriangular:Matrix = LUPDecomposition(1)
		PermutationArray:[]int = LUPDecomposition(2)
		LUPSolve(LowerTriangular, UpperTriangular, PermutationArray, b)

	# Internal solution for linear systems of equations
	LUPSolve<internal>(L:Matrix, U:Matrix, p:[]int, b:[]float)<transacts>:[]float=
		Rows:int=L.Rows
		var IntermediateVector:[]float = array{}
		var SolutionVector:[]float = for(Row:=0..Rows-1):
			0.0
		for (Row:=0..Rows-1, PermutationElement:=b[p[Row]]):
			var PartialSum:float = 0.0
			for:
				Col:=0..Row-1
				LRowCol:=L.Rep[Row][Col]
				IntermediateVectorTemp:=IntermediateVector[Col]
			do:
				set PartialSum += LRowCol * IntermediateVectorTemp
			set IntermediateVector += array{PermutationElement - 1.0 * PartialSum}
		for:
			Row:=0..Rows-1
			ReverseRow:=Rows-1-Row
			IntermediateVectorTemp:=IntermediateVector[ReverseRow]
			URowRow:=U.Rep[ReverseRow][ReverseRow]
		do:
			var PartialSum:float = 0.0
			for:
				Col:=ReverseRow+1..Rows-1
				URowCol:=U.Rep[ReverseRow][Col]
				SolutionVectorTemp:=SolutionVector[Col]
			do:
				set PartialSum += URowCol * SolutionVectorTemp
			if (set SolutionVector[ReverseRow] = (IntermediateVectorTemp - PartialSum) / URowRow):
		SolutionVector

	# Summary: Obtain the LU-Decomposition of the matrix A
	# Fails: A is singular
	# Complexity: Theta(n^3)
	LU<public>(A:Matrix)<decides><transacts>:tuple(Matrix,Matrix)=
		Size:int=A.Rows
		var ATemp:Matrix=A.Copy()
		var L:Matrix=Identity(Size)
		var U:Matrix=Zeros(Size,Size)
		for (k:=0..Size-1):
			UTempMatrix:=U.SetElementAtIndex[(k,k), ATemp.Rep[k][k]]
			set U = UTempMatrix
			for (i:=k+1..Size-1):
				LTempMatrix:=L.SetElementAtIndex[(i,k), ATemp.Rep[i][k] / ATemp.Rep[k][k]]
				set L = LTempMatrix
				UInnerTempMatrix:=U.SetElementAtIndex[(k,i), ATemp.Rep[k][i]]
				set U = UInnerTempMatrix
			for (i:=k+1..Size-1):
				for (j:=k+1..Size-1):
					Aij:=ATemp.Rep[i][j]
					AInnerTemp:=ATemp.SetElementAtIndex[(i,j), Aij - (L.Rep[i][k] * U.Rep[k][j])]
					set ATemp = AInnerTemp
		(L,U)

	# Summary: Obtain the LUP-Decomposition of the matrix A such that PA=LU
	#		where:
	#			L - lower triangular
	#			U - upper triangular
	#			P - permutation matrix
	# Fails: A is singular
	# Complexity: Theta(n^3)
	LUP<public>(A:Matrix)<decides><transacts>:tuple(Matrix,Matrix,[]int)=
		Size:int=A.Rows
		var ATemp:Matrix=A.Copy()
		var PermutationArray:[]int = for(i:=0..Size-1):
			i
		for (k:=0..Size-1):
			var PVal:float = 0.0
			var Kprime:int = 0
			for (i:=k..Size-1):
				if (Aik:=Abs(ATemp.Rep[i][k]), Aik > PVal):
					set PVal = Aik
					set Kprime = i
			# If PVal = 0, then PVal is singular and the procedure fails
			PVal <> 0.0
			SwappedArray:=PermutationArray.Swap[k,Kprime]
			set PermutationArray = SwappedArray
			for (i:=0..Size-1):
				FirstTemp:=ATemp.Rep[k][i]
				SecondTemp:=ATemp.Rep[Kprime][i]
				FirstTempMat:=ATemp.SetElementAtIndex[(Kprime,i), FirstTemp]
				SecondTempMat:=FirstTempMat.SetElementAtIndex[(k,i), SecondTemp]
				set ATemp = SecondTempMat
			for (i:=k+1..Size-1):
				ThirdTempMat:=ATemp.SetElementAtIndex[(i,k), ATemp.Rep[i][k] / ATemp.Rep[k][k]]
				set ATemp = ThirdTempMat
				for (j:=k+1..Size-1):
					FourthTempMat:=ATemp.SetElementAtIndex[(i,j), ATemp.Rep[i][j] - (ATemp.Rep[i][k] * ATemp.Rep[k][j])]
					set ATemp = FourthTempMat
		L:Matrix=ATemp.ExtractLowerTriangle[]
		U:Matrix=ATemp.ExtractUpperTriangle[]
		(L, U, PermutationArray)

	# Extract the upper triangular matrix from the LUP algorithm implementation
	(InMatrix:Matrix).ExtractUpperTriangle<internal>()<decides><transacts>:Matrix=
		var OutMatrix:Matrix=Zeros(InMatrix.Rows,InMatrix.Cols)
		for (i:=0..InMatrix.Rows-1, j:=0..InMatrix.Cols-1, i <= j):
			Temp:=OutMatrix.SetElementAtIndex[(i,j), InMatrix.Rep[i][j]]
			set OutMatrix = Temp
		OutMatrix

	# Extract the lower triangular matrix from the LUP algorithm implementation
	(InMatrix:Matrix).ExtractLowerTriangle<internal>()<decides><transacts>:Matrix=
		var OutMatrix:Matrix=Identity(InMatrix.Rows)
		for (i:=0..InMatrix.Rows-1, j:=0..InMatrix.Cols-1, i > j):
			Temp:=OutMatrix.SetElementAtIndex[(i,j), InMatrix.Rep[i][j]]
			set OutMatrix = Temp
		OutMatrix

	# Convert a permutation array into a permutation matrix
	(InArray:[]int).ToPermutationMatrix<public>()<decides><transacts>:Matrix=
		Size:int = InArray.Length
		SortedArray:=SortBy(InArray, IntegerLessThan)
		RangeArray:=for (i:=0..Size-1). 1.0 * i
		for (i:=0..Size-1):
			1.0 * SortedArray[i] = RangeArray[i]
		var OutMatrix:Matrix=Zeros(Size)
		for (i:=0..Size-1, j:=InArray[i]):
			MatrixTemp:=OutMatrix.SetElementAtIndex[(i,j), 1.0]
			set OutMatrix = MatrixTemp
		OutMatrix

	<# CODE UTILITIES #>
 
	# String rep of matrix
	ToString<public>(InMatrix:Matrix)<transacts>:[]char=
		var ReturnString:[]char = "\n"
		for (Row:=0..InMatrix.Rows-1):
			set ReturnString += "\t"
			for (Col:=0..InMatrix.Cols-1, Entry:=InMatrix.Rep[Row][Col]):
				set ReturnString += "{Entry} "
			set ReturnString += "\n"
		ReturnString

	# String rep of float array
	ArrayToString<public>(InArray:[]float)<transacts>:[]char=
		var ReturnString:[]char = "\{"
		for (Entry:InArray):
			set ReturnString += " {Entry} "
		set ReturnString += "\}\n"
		ReturnString

	# String rep of float array
	IntArrayToString<public>(InArray:[]int)<transacts>:[]char=
		var ReturnString:[]char = "\{"
		for (Entry:InArray):
			set ReturnString += " {Entry} "
		set ReturnString += "\}\n"
		ReturnString

Arrays<public> := module:
 
	# Array utility to swap the elements contained in indices I and J
	(Array:[]t where t:type).Swap<public>(FirstIndex:int, SecondIndex:int)<decides><transacts>:[]t =
		ArrayTemp := Array.ReplaceElement[FirstIndex, Array[SecondIndex]]
		return ArrayTemp.ReplaceElement[SecondIndex, Array[FirstIndex]]

Comparisons<public> := module:
	IntegerLessThan<public>(A:int, B:int)<decides><computes>:void =
		A < B
	IntegerEquivalent<public>(A:int, B:int)<decides><computes>:void =
		A = B
