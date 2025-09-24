
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
using { Matrices }
using { DSAV }


dsav_code := class(creative_device):

    @editable AimTrainingButton : button_device = button_device{}
    @editable AimTrainingProp : creative_prop = creative_prop{}
    @editable AimTrainingZone : prop_manipulator_device = prop_manipulator_device{}
    @editable Beta1SignDiffFromZero : analytics_device = analytics_device{}
    @editable Beta1NotSignDiffFromZero : analytics_device = analytics_device{}

    var Trial : int = 0
    var GameTime : float = 0.0
    var PropCoords : vector3 = vector3{X:=0.0,Y:=0.0,Z:=0.0}

    # Defining samples:
    @editable var x_array : []?float = for (Index := 0..50-1): # Set n = 50
        false
    @editable var y_array : []?float = for (Index := 0..50-1): # Set n = 50
        false
    
    OnBegin<override>()<suspends>:void= 
        AimTrainingButton.InteractedWithEvent.Subscribe(SpawnAimTrainingProp)
        AimTrainingZone.DamagedEvent.Subscribe(SpawnAimTrainingProp)

    SpawnAimTrainingProp(Agent:agent):void=  # Set up a recursive function to relocate the target, until all entries in the defined arrays are filled
        if (Trial > 0):
            if (set y_array[Trial-1] = option{GetSimulationElapsedTime() - GameTime}) {}  # Set each y-entry as the time taken to hit a target
        set GameTime = GetSimulationElapsedTime()

        PropRotation := AimTrainingProp.GetTransform().Rotation
        if (Trial <= x_array.Length):
            RandomX := GetRandomFloat(-400.0,400.0)  # Define a new random position for the target
            RandomY := GetRandomFloat(0.0,2000.0)
            RandomZ := GetRandomFloat(100.0,300.0)
            if (AimTrainingProp.TeleportTo[transform{Translation := vector3{X:=RandomX,Y:=RandomY,Z:=RandomZ},Rotation := PropRotation}]) {}  # Teleport the prop to that position
            
            if (Trial > 0):
                if (Trial = 1):
                    if (set x_array[0] = option{0.0}) {}
                else:
                    if (set x_array[Trial-1] = option{Distance(vector3{X:=RandomX,Y:=RandomY,Z:=RandomZ}, PropCoords)}) {}  # Set each x-entry as the distance between consecutive targets
            set PropCoords = vector3{X:=RandomX,Y:=RandomY,Z:=RandomZ}

            set Trial += 1
        else:  # Finishing condition
            if (AimTrainingProp.TeleportTo[transform{Translation := vector3{X:=0.0,Y:=0.0,Z:=-200.0},Rotation := PropRotation}]) {}  # Hide the target
            Print("Aim training finished")
            
            if (Plot := ScatterPlot[OptionalArrayToArray(x_array), OptionalArrayToArray(y_array),
             ?XAxisLabel:= "Distance between consecutive targets", ?YAxisLabel:= "Time taken (s) per target",
             ?Title:= "Scatter plot of hit times and distances between consecutive targets", ?Fit := true]):
                Plot  # Make the scatter plot

                <# COMING IN VERSION 2: 
                if (xMat := VectorAsMatrix[OptionalArrayToArray(x_array)], Betas := OLSEstimates[xMat, OptionalArrayToArray(y_array), ?Intercept := true], Beta1 := Betas[1]):
                    if (Beta1.IsSignificant()):  
                        Beta1SignDiffFromZero.Submit(Agent)  # Store the number of cases where the gradient is statistically significant in the Creator Portal for further analysis
                    else:
                        Beta1NotSignDiffFromZero.Submit(Agent)
                #>

            else:
                Print("Error: Invalid plot")