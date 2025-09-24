# DSAV (Data Science & Analytics for Verse) module
DSAV<public> := module:

    # NOTE: Project DSAV uses the Matrices module made by @topo-ology. This required module can be found here: 
    # https://dev.epicgames.com/community/snippets/bO9r/fortnite-matrices
    using { Matrices }
    using { /UnrealEngine.com/Temporary/SpatialMath }
    using { /Verse.org/Random }

    <# DESCRIPTIVE STATISTICS; UNIVARIATE #>

    # Calculates the average value of an array of floats.
    (Column:[]float).Mean<public>()<decides><transacts>:float=
        var Sum : float = 0.0
        for (Index := 0..Column.Length - 1):
            if (Entry := Column[Index]):
                set Sum += Entry
        (1.0*Sum)/(1.0*Column.Length)

    # Calculates the average value of a column in a matrix.
    (InMatrix:Matrix).Mean<public>(Column:int)<decides><transacts>:float=
        InRows : int = InMatrix.Rows
        var Sum : float = 0.0
        for (Index := 0..InRows - 1):
            if (Entry := InMatrix.Rep[Index][Column]):
                set Sum += Entry
        (1.0*Sum)/(1.0*InRows)

    # Calculates the population variance of an array of floats.
    (Column:[]float).Var<public>()<decides><transacts>:float=
        Mean : float = Column.Mean[]
        SquaredTerms : []float = for (Index := 0..Column.Length - 1):
            Pow(Column[Index] - Mean,2.0)
        var Sum : float = 0.0
        for (Index := 0..SquaredTerms.Length - 1):
            set Sum += SquaredTerms[Index]
        (1.0*Sum)/(1.0*Column.Length)

    # Calculates the population variance of a column in a matrix.
    (InMatrix:Matrix).Var<public>(Column:int)<decides><transacts>:float=
        InRows : int = InMatrix.Rows
        Mean : float = InMatrix.Mean[Column]
        SquaredTerms : []float = for (Index := 0..InRows - 1):
            Pow(InMatrix.Rep[Index][Column] - Mean,2.0)
        var Sum : float = 0.0
        for (Index := 0..InRows - 1):
            set Sum += SquaredTerms[Index]
        (1.0*Sum)/(1.0*InRows)

    # Calculates the sample variance of an array of floats.
    (Column:[]float).SVar<public>()<decides><transacts>:float=
        Variance : float = Column.Var[]
        Variance*((1.0*Column.Length)/(1.0*Column.Length-1.0))

    # Calculates the sample variance of a column in a matrix.
    (InMatrix:Matrix).SVar<public>(Column:int)<decides><transacts>:float=
        InRows : int = InMatrix.Rows
        Variance : float = InMatrix.Var[Column]
        Variance*((1.0*InRows)/(1.0*InRows-1.0))

    # Calculates the population standard deviation of an array of floats.
    (Column:[]float).StdDev<public>()<decides><transacts>:float=
        Variance : float = Column.Var[]
        Sqrt(Variance)

    # Calculates the population standard deviation of a column in a matrix.
    (InMatrix:Matrix).StdDev<public>(Column:int)<decides><transacts>:float=
        Variance : float = InMatrix.Var[Column]
        Sqrt(Variance)

    # Calculates the sample standard deviation of an array of floats.
    (Column:[]float).SStdDev<public>()<decides><transacts>:float=
        SampleVariance : float = Column.SVar[]
        Sqrt(SampleVariance)

    # Calculates the sample standard deviation of a column in a matrix.
    (InMatrix:Matrix).SStdDev<public>(Column:int)<decides><transacts>:float=
        SampleVariance : float = InMatrix.SVar[Column]
        Sqrt(SampleVariance)


    <# DESCRIPTIVE STATISTICS; MULTIIVARIATE #>

    # Calculates the sample covariance of 'x' and 'y', being arrays of floats. Fails if their number of entries are different.
    Cov<public>(x:[]float, y:[]float)<decides><transacts>:?float =
        block:
            var Sum : float = 0.0
            if (x.Length <> y.Length):
                false
            else:
                for (Entry := 0..x.Length-1):
                    Term : float = (x[Entry] - x.Mean[]) * (y[Entry] - y.Mean[])
                    set Sum += Term
            option{(1.0*Sum) / (1.0*x.Length - 1.0)}

    # Calculates the sample covariance of column 'XCol' of matrix 'X' and column 'YCol' of matrix 'Y'. Fails if their number of entries are different.
    Cov<public>(X:Matrix, Y:Matrix, XCol : int, YCol : int)<decides><transacts>:?float =
        block:
            var Sum : float = 0.0
            if (X.Rows <> Y.Rows):
                false
            else:
                for (Entry := 0..X.Rows-1):
                    Term : float = (X.Rep[Entry][XCol] - X.Mean[XCol]) * (Y.Rep[Entry][YCol] - Y.Mean[YCol])
                    set Sum += Term
            option{(1.0*Sum) / (1.0*X.Rows - 1.0)}
            
    # Calculates the covariance matrix of columns in 'X'.
    Cov<public>(X:Matrix)<decides><transacts>:Matrix =
        block:
            Result : [][]float = for (Row :=0..X.Cols- 1):
                for (Col :=0..X.Cols- 1):
                    Cov[X, X, Row, Col]?
            ConstructMatrix[Result]

    # Calculates the Pearson correlation coefficient of 'x' and 'y', being arrays of floats. Fails if their number of entries are different.
    Corr<public>(x:[]float, y:[]float)<decides><transacts>:?float =
        block:
            var Result : float = 0.0
            if (x.Length <> y.Length):
                false
            else:
                if (UnfailedCov := Cov[x,y]?):
                    set Result = UnfailedCov
            Denominator : float = x.SStdDev[] * y.SStdDev[]
            set Result /= Denominator
            option{Result}

    # Calculates the Pearson correlation coefficient of 'x' and 'y', being columns in a matrix. Fails if their number of entries are different.
    Corr<public>(X:Matrix, Y:Matrix, XCol : int, YCol : int)<decides><transacts>:?float =
        block:
            var Result : float = 0.0
            if (X.Rows <> Y.Rows):
                false
            else:
                if (UnfailedCov := Cov[X, Y, XCol, YCol]?):
                    set Result = UnfailedCov
            Denominator : float = X.SStdDev[XCol] * Y.SStdDev[YCol]
            set Result /= Denominator
            option{Result}

    # Calculates the coefficient of determination of 'x' and 'y', being arrays of floats. Fails if their number of entries are different.
    R2<public>(x:[]float, y:[]float)<decides><transacts>:?float =
        block:
            if (x.Length <> y.Length):
                false
            else:
                var Result : float = Corr[x, y]?
                set Result = Pow(Result, 2.0)
                option{Result}

    # Calculates the coefficient of determination of 'x' and 'y', being columns in a matrix. Fails if their number of entries are different.
    R2<public>(X:Matrix, Y:Matrix, XCol : int, YCol : int)<decides><transacts>:?float =
        block:
            if (X.Rows <> Y.Rows):
                false
            else:
                var Result : float = Corr[X, Y, XCol, YCol]?
                set Result = Pow(Result, 2.0)
                option{Result}


    <# REGRESSION #>

    # Performs Ordinary Least Squares to derive coefficient estimates for 'X', with option to add the intercept term, such that 'y' is linearly explained by 'X'. Fails if either:
    #  * X and y have an unequal number of rows
    #  * XtX is invertible
    OLSEstimates<public>(X:Matrix, y:[]float, ?Intercept : logic = false)<decides><transacts>:[]float =
        block:
            var XResult : Matrix = Matrix{}
            if (Intercept = true):
                XWithOnesRep : [][]float = for (Row := 0..X.Rows - 1):
                    for (Col := 0..X.Cols):
                        if (Col = 0):
                            1.0
                        else:
                            X.Rep[Row][Col-1]
                XWithOnes : Matrix = ConstructMatrix[XWithOnesRep]
                set XResult = XWithOnes
            else:
                set XResult = X
            Xt :Matrix = XResult.Transpose[]
            XtX :Matrix = Xt*XResult
            XtXinv : Matrix = XtX.Inverse[]
            yMatrixForm : Matrix = VectorAsMatrix[y]
            Xty : Matrix = Xt * yMatrixForm
            BetaHat : Matrix = XtXinv * Xty
            MaybeTheResult : ?[]float = OneDMatrixAsVector[BetaHat]
            Result : []float = MaybeTheResult?
            Result

    # Prints an ASCII scatter plot graph in the output log, given data points (x[i], y[i]) and optional titles. Provides the option to return the line equation of best fit.
    ScatterPlot<public>(x:[]float, y:[]float, ?XAxisLabel : string = "", ?YAxisLabel : string = "", ?Title : string = "", ?Fit : logic = false)<decides><transacts>:void =
        if (x.Length <> y.Length):
            Print("Error: Arrays x and y have unequal length.")
        else if (x.Length = 0 or y.Length = 0):
            Print("Error: One of the input arrays have length 0.")
        else if (x.Length = 1 or y.Length = 1):
            Print("Error: At least 2 data points are needed to plot the graph.")
        else block:
            var MinX : float = 0.0
            var MaxX : float = 0.0
            var MinY : float = 0.0
            var MaxY : float = 0.0
            if (FirstEntry := x[0]):
                set MinX = FirstEntry
                set MaxX = FirstEntry
                for (Index := 1..x.Length-1):
                    if (EntryX := x[Index], EntryY := y[Index]):
                        if (EntryX < MinX):
                            set MinX = EntryX
                        else if (EntryX > MaxX):
                            set MaxX = EntryX
                        if (EntryY < MinY):
                            set MinY = EntryY
                        else if (EntryY > MaxY):
                            set MaxY = EntryY

            RangeX : float = MaxX - MinX
            RangeY : float = MaxY - MinY
            SignificantFiguresX : float = if (RangeX > 0.0, LogResult := Log(10.0, RangeX)):
                1.0*Ceil[LogResult]
            else:
                1.0
            SignificantFiguresY : float = if (RangeY > 0.0, LogResult := Log(10.0, RangeY)):
                1.0*Ceil[LogResult]
            else:
                1.0

            var StepX : float = 0.0
            if (RangeX <= 2.0 * Pow(10.0, SignificantFiguresX - 1.0)):
                set StepX = 0.5 * Pow(10.0, SignificantFiguresX - 1.0)
            else if (RangeX <= 4.0 * Pow(10.0, SignificantFiguresX - 1.0)):
                set StepX = Pow(10.0, SignificantFiguresX - 1.0)
            else if (RangeX <= 8.0 * Pow(10.0, SignificantFiguresX - 1.0)):
                set StepX = 2.0 * Pow(10.0, SignificantFiguresX - 1.0)
            else:
                set StepX = 5.0 * Pow(10.0, SignificantFiguresX - 1.0)

            var StepY : float = 0.0
            if (RangeY <= 2.0 * Pow(10.0, SignificantFiguresY - 1.0)):
                set StepY = 0.5 * Pow(10.0, SignificantFiguresY - 1.0)
            else if (RangeY <= 4.0 * Pow(10.0, SignificantFiguresY - 1.0)):
                set StepY = Pow(10.0, SignificantFiguresY - 1.0)
            else if (RangeY <= 8.0 * Pow(10.0, SignificantFiguresY - 1.0)):
                set StepY = 2.0 * Pow(10.0, SignificantFiguresY - 1.0)
            else:
                set StepY = 5.0 * Pow(10.0, SignificantFiguresY - 1.0)

            NumberlineX : []float = for (Index := 0..23 - 1):
                NearestMultiple[MinX, StepX] + 0.2*(Index - 1)*StepX
            NumberlineY : []float = for (Index := 0..19 - 1):
                NearestMultiple[MinY, StepY] + 0.25*(Index - 1)*StepY

            RoundedPositionX : []float = for (Index := 0..x.Length-1):
                ( NearestMultiple[x[Index], 0.2*StepX] - NumberlineX[0])/(0.2*StepX)
            RoundedPositionY : []float = for (Index := 0..y.Length-1):
                (NearestMultiple[y[Index], 0.25*StepY] - NumberlineY[0])/(0.25*StepY)

            var ResultRep : [][]float = for (Row := 0..19-1):
                for (Col := 0..23-1):
                    0.0
            for (Index := 0..RoundedPositionX.Length-1):
                if (IndexX := Int[RoundedPositionX[Index]], IndexY := Int[RoundedPositionY[Index]]):
                    set ResultRep[19 - 1 - IndexY][IndexX] = 250.0
            RawPlot : Matrix = ConstructMatrix[ResultRep]

            FrameRep : [][]float = for (Row := 0..22-1):
                for (Col := 0..27-1):
                    if (Col = 0):
                        if (Row = 2 or Row = 6 or Row = 10 or Row = 14 or Row = 18):
                            45.0
                        else:
                            0.0
                    else if (Col = 1):
                        if (Row = 0):
                            94.0
                        else if (Row = 21):
                            0.0
                        else:
                            124.0
                    else if (Row = 20):
                        if (Col = 26):
                            62.0
                        else:
                            95.0
                    else if (Row = 21):
                        if (Col = 4 or Col = 9 or Col = 14 or Col = 19 or Col = 24):
                            39.0
                        else:
                            0.0
                    else:
                        if (Entry := RawPlot.Rep[Row-1][Col-3]):
                            Entry
                        else:
                            0.0
            
            Graph : Matrix = ConstructMatrix[FrameRep]

            NumberlineXFirst : float = NumberlineX[1]
            NumberlineXLast : float = NumberlineX[NumberlineX.Length - 2]
            DistanceBetweenNumberlineXValues : int = 40 - FloatToTrimmedString[NumberlineXFirst].Length
            var SpaceBetweenNumberlineXValues : string = "" 
            for (Index := 0..DistanceBetweenNumberlineXValues - 1):
                set SpaceBetweenNumberlineXValues += " "

            NumberlineYFirst : float = NumberlineY[NumberlineY.Length - 2]
            NumberlineYLast : float = NumberlineY[1]
            
            DistanceForNumberlineYValues : int = Max(FloatToTrimmedString[NumberlineYFirst].Length, FloatToTrimmedString[NumberlineYLast].Length)
            var SpaceOfDistanceOfNumberlineYValues : string = ""
            for (Index := 0..DistanceForNumberlineYValues - 1):
                set SpaceOfDistanceOfNumberlineYValues += " "
            DifferenceInDistanceOfNumberlineYValues : int = Abs(FloatToTrimmedString[NumberlineYFirst].Length - FloatToTrimmedString[NumberlineYLast].Length)
            var SpaceDifferenceOfDistanceOfNumberlineYValues : string = ""
            for (Index := 0..DifferenceInDistanceOfNumberlineYValues - 1):
                set SpaceDifferenceOfDistanceOfNumberlineYValues += " "

            DisplayedNumberlineYFirst : string = 
                if (FloatToTrimmedString[NumberlineYFirst].Length > FloatToTrimmedString[NumberlineYLast].Length):
                    FloatToTrimmedString[NumberlineYFirst]
                else:
                    SpaceDifferenceOfDistanceOfNumberlineYValues + FloatToTrimmedString[NumberlineYFirst]
            DisplayedNumberlineYLast : string = 
                if (FloatToTrimmedString[NumberlineYFirst].Length > FloatToTrimmedString[NumberlineYLast].Length):
                    SpaceDifferenceOfDistanceOfNumberlineYValues + FloatToTrimmedString[NumberlineYLast]
                else:
                    FloatToTrimmedString[NumberlineYLast]
            
            var ReturnString:[]char = "\n"
            for (Row:=0..Graph.Rows-1):
                if (Row = 2):
                    set ReturnString += "\t{DisplayedNumberlineYFirst}"
                else if (Row = 18):
                    set ReturnString += "\t{DisplayedNumberlineYLast}"
                else:
                        set ReturnString += "\t{SpaceOfDistanceOfNumberlineYValues}"
                for (Col:=0..Graph.Cols-1, Entry:=Graph.Rep[Row][Col]):
                    if (StringValue := ASCIIMap[Int[Entry]]):
                        set ReturnString += StringValue
                        if (Row = 0 and Col = 2 and YAxisLabel.Length > 0):
                            set ReturnString += "-{YAxisLabel}-"
                    else:
                        set ReturnString += "? "
                set ReturnString += "\n"
            set ReturnString += 
                "\t        {SpaceOfDistanceOfNumberlineYValues}{FloatToTrimmedString[NumberlineXFirst]}{SpaceBetweenNumberlineXValues}{FloatToTrimmedString[NumberlineXLast]}"
            if (Title.Length > 0):
                Print("***** {Title} *****")
            Print("{ReturnString}")
            if (XAxisLabel.Length > 0):
                Print("     -{XAxisLabel}-")
            if (Fit = true, xMat := VectorAsMatrix[x], Betas := OLSEstimates[xMat, y, ?Intercept := true], Intercept := Betas[0], Gradient := Betas[1]):
                Print("Line of best fit: y = {Gradient}x + {Intercept}")
            Print("See Output Log window for an accurate representation\n")

    # Calculates the mean of the absolute error terms of the model defined by 'BetaHat', such that 'y' is explained by 'X'.
    MeanSquaredError<public>(X:Matrix, y:[]float, BetaHat:[]float)<decides><transacts>:float =
        block:
            InRows : int = X.Rows
            InCols : int = X.Cols
            SquaredErrors : []float = for(Row:=0..InRows-1):
                var yHat : float = 0.0
                for(Col:=0..InCols-1):
                    XjBj : float = X.Rep[Row][Col] * BetaHat[Col]
                    set yHat += XjBj
                Error : float = y[Row] - yHat
                Element : float = Pow(Error, 2.0)
                Element
            var Sum : float = 0.0
            for(Row:=0..InRows-1):
                if (Element := SquaredErrors[Row]):
                    set Sum += Element
            (1.0*Sum)/(1.0*InRows)

    # Calculates the root of the Mean Squared Error.
    RootMeanSquaredError<public>(X:Matrix, y:[]float, BetaHat:[]float)<decides><transacts>:float =
        block:
            MSE : float = MeanSquaredError[X, y, BetaHat]
            RMSE : float = Sqrt(MSE)
            RMSE

    # Calculates the mean of the absolute error terms of the model defined by 'BetaHat', such that 'y' is explained by 'X'.
    MeanAbsoluteError<public>(X:Matrix, y:[]float, BetaHat:[]float)<decides><transacts>:float =
        block:
            InRows : int = X.Rows
            InCols : int = X.Cols
            AbsoluteErrors : []float = for(Row:=0..InRows-1):
                var yHat : float = 0.0
                for(Col:=0..InCols-1):
                    XjBj : float = X.Rep[Row][Col] * BetaHat[Col]
                    set yHat += XjBj
                var Error : float = y[Row] - yHat
                if (Error < 0.0):
                    set Error *= -1.0
                Error
            var Sum : float = 0.0
            for(Row:=0..InRows-1):
                if (Element := AbsoluteErrors[Row]):
                    set Sum += Element
            (1.0*Sum)/(1.0*InRows)

    # Divides the Mean Squared Error by the population variance of 'y'.
    NormalizedMeanSquaredError<public>(X:Matrix, y:[]float, BetaHat:[]float)<decides><transacts>:float =
        block:
            MSE : float = MeanSquaredError[X, y, BetaHat]
            NMSE : float = MSE / y.Var[]
            NMSE


    <# DISTRIBUTIONS #>

    # Draws from an approximated normal distribution with mean 'Mu' and standard deviation 'Sigma'
    RandNormPDF<public>(Mu:float, Sigma:float)<transacts>:float =
        block:
            RandU1:float = GetRandomFloat(0.0, 1.0)
            RandU2:float = GetRandomFloat(0.0, 1.0)
            Z:float = Sqrt(-2.0*Ln(RandU1)) * Cos(2.0*PiFloat*RandU2) # Box-Muller algorithm
            Result:float = Sigma * Z + Mu
            Result

    # Draws from an approximated lognormal distribution with mean 'Mu' and standard deviation 'Sigma' of the normal.
    RandLogNormPDF<public>(Mu:float, Sigma:float)<transacts>:float =
        block:
            Y :float = RandNormPDF(Mu, Sigma)
            Exp(Y)


    <# HELPER FUNCTIONS #>

    # Converts an array of floats 'Input' to a 1-dimentional matrix
    VectorAsMatrix<public>(Input : []float)<decides><transacts>: Matrix =
        block:
            Result : [][]float = for (Element : Input):
                array{Element}
            ConstructMatrix[Result]

    # Converts a 1-dimentional matrix 'Input' to an array of floats. Fails if the matrix has more than one column.
    OneDMatrixAsVector<public>(Input : Matrix)<decides><transacts>: ?[]float =
        block:
            InRows : int = Input.Rows
            InCols : int = Input.Cols
            if (InCols <> 1):
                false
            Result : []float = for(Row:=0..InRows-1):
                if (Element := Input.Rep[Row][0]):
                    Element
                else:
                    0.0
            option{Result}

    # Converts an array with optional floats to an array with floats.
    OptionalArrayToArray<public>(OptArray : []?float)<transacts>: []float =
        for (MaybeAFloat : OptArray, Value := MaybeAFloat?):
            Value

    # Returns a submatrix with reduced rows ('Dimention' = 0) or reduced columns ('Dimention' = 1), selecting the rows/columns specified in 'Scope'.
    (InMatrix:Matrix).Submatrix<public>(Dimention: int, Scope:[]int)<decides><transacts>:Matrix=
        block:
            var NRows : int = 0
            var NCols : int = 0
            if (Dimention = 0):
                set NRows = Scope.Length
                set NCols = InMatrix.Cols
                Result : [][]float = for (Index : Scope):
                    InMatrix.Rep[Index]
                ConstructMatrix[Result]
            else:
                set NRows = InMatrix.Rows
                set NCols = Scope.Length
                Result : [][]float = for (Row := 0..NRows- 1):
                    for (Index := 0..NCols- 1):
                        InMatrix.Rep[Row][Index]
                ConstructMatrix[Result]

    # Helper function for ScatterPlot(). Returns 'Number' rounded to the nearest 'X'.
    NearestMultiple<public>(Number: float, X: float)<decides><transacts>: float =
        var Result : float = 0.0
        DivisionResult := Number / X
        if (RoundedResult := Round[DivisionResult]):
            set Result = RoundedResult * X
        Result

    # Helper function for ScatterPlot(). Returns 'Number' in string format without unnecessary decimal places.
    FloatToTrimmedString<public>(Number: float)<decides><transacts>: string =
        StringForm : string = ToString(Number)
        var TrimmedString : string = ""
        if (Number - 1.0*Round[Number] = 0.0):
            var DecimalIndex : int = 99
            for (Index := 0..StringForm.Length - 1):
                if (Digit := StringForm[Index]):
                    if (Digit = '.'):
                        set DecimalIndex = Index
                    else if (Index < DecimalIndex):
                        set TrimmedString += "{Digit}"
            TrimmedString
        else:
            var DecimalPlacesToCut : int = 0
            var NonZeroFound : logic = false
            for (Index := 0..6-1):
                if (NonZeroFound = false, DecimalDigit := StringForm[StringForm.Length - 1 - Index]):
                    if (DecimalDigit <> '0'):
                        set NonZeroFound = true
                    else:
                        set DecimalPlacesToCut += 1
            set TrimmedString = StringForm
            TrimmedString.Slice[0, StringForm.Length - DecimalPlacesToCut]
        

    # Limited ASCII Map of digits to symbols. For simplicity, 'space' is mapped to 0. 
    # Reference: https://theasciicode.com.ar/ascii-printable-characters/single-quote-apostrophe-ascii-code-39.html
    ASCIIMap<public>: [int]string = map{
        250 => "· ",
        124 => "| ",
        95  => "_ ",
        94  => "^ ",
        62  => "> ",
        45  => "- ",
        39  => "' ",
        0   => "  "

    }
