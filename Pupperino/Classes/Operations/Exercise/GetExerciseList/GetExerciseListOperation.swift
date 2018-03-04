
import UIKit

class GetExerciseListOperation: TSMBaseServerOperation {

    // MARK: - Methods
    // MARK: - Overriding TSMBaseOperation
    
    override func createOutput() -> TSMBaseOperationOutput {
        return GetExerciseListOutput()
    }
    
    // MARK: - Overriding TSMBaseServerOperation
    
    override func urlMethodName() -> String {
        guard let input = input as? GetExerciseListInput else {
            return "exercise/list/"
        }
        
        return "exercise/list/\(input.page)"
    }
    
    override func httpMethod() -> String {
        return "GET"
    }
    
    override func additionalUrlParametersDictionary() -> [String: String]? {
        return nil
    }
    
    override func parseResponseDictionary(_ responseDictionary: [String: Any]) {
        
        guard let exercisesDictionaryList = responseDictionary["exercises"] as? [[String: Any]] else {
            log("WARNING: could not parse `exercises` from response dictionary \(responseDictionary)")
            return
        }
        
        var exerciseList: [ExerciseEntity] = []
        exerciseList.reserveCapacity(exercisesDictionaryList.count)
        
        for exerciseDictionary in exercisesDictionaryList {
            if let exercise = ExerciseEntity(withDictionary: exerciseDictionary) {
                exerciseList.append(exercise)
            } else {
                log("WARNING: could not parse source from source dictionary \(exerciseDictionary)")
            }
        }
        
        output().exerciseList = exerciseList
        output.isSuccessful = true
    }
    
    // MARK: - Public helpers
    
    func output() -> GetExerciseListOutput {
        // swiftlint:disable force_cast
        return output as! GetExerciseListOutput
        // swiftlint:enable force_cast
    }
}
