import '../models/people_model.dart';
import '../repos/repositories.dart';

class PeopleController {
  late Repository _repository;
  PeopleController() {
    _repository = Repository();
  }

  Future<void> insertPeople(PeopleModel data) {
    return _repository.insertPeople(data);
  }

  Future<List<PeopleModel>> selectPeople() async {
    var response = await _repository.selectPeople() as List;
    List<PeopleModel> peopleList = [];
    response.map((value) {
      return peopleList.add(PeopleModel.fromJson(value));
    }).toList();
    return peopleList;
  }

  Future<void> deletePeople(int peopleId) {
    return _repository.deletePeople(peopleId);
  }

  Future<void> updatePeople(PeopleModel peopleModel) {
    return _repository.updatePeople(
      peopleModel.toJson(),
      peopleModel.id,
    );
  }
}
