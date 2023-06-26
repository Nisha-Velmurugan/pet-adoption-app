import 'package:get_it/get_it.dart';
import 'package:pet_adoption_app/data/api/api_client.dart';
import 'package:pet_adoption_app/data/repositories/api_repository.dart';
import 'package:pet_adoption_app/data/repositories/shared_local_storage_impl.dart';
import 'package:pet_adoption_app/data/use_cases/adopt_pet_use_case_impl.dart';
import 'package:pet_adoption_app/data/use_cases/get_pet_detail_use_case_impl.dart';
import 'package:pet_adoption_app/data/use_cases/get_pets_use_case_impl.dart';
import 'package:pet_adoption_app/data/use_cases/mock/mock_adopt_pet_use_case.dart';
import 'package:pet_adoption_app/data/use_cases/mock/mock_get_pets_use_case.dart';
import 'package:pet_adoption_app/domain/repositories/local_storage_repository.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';
import 'package:pet_adoption_app/domain/use_cases/adopt_pet_use_case.dart';
import 'package:pet_adoption_app/domain/use_cases/get_pet_detail_use_case.dart';
import 'package:pet_adoption_app/domain/use_cases/get_pets_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> setup() async {
  final sharedPref = await SharedPreferences.getInstance();
  configureDependencies(sharedPref);
}

void configureDependencies(SharedPreferences sharedPreferences) {
  getIt.registerSingleton<LocalStorageRepository>(
      SharedPreferencesLocalStorageImpl(sharedPreferences));
  getIt.registerSingleton<ApiClient>(ApiClient());
  setupRepository();

  const isMockUsecase = true;

  if (isMockUsecase) {
    setupMockUsecase();
  } else {
    setupUsecase();
  }
}

void setupRepository() {
  getIt.registerFactory<PetRepository>(() => ApiRepository(getIt.get()));
}

void setupUsecase() {
  getIt.registerFactory<GetPetsUseCase>(() => GetPetsUseCaseImpl(getIt.get()));
  getIt
      .registerFactory<AdoptPetUseCase>(() => AdoptPetUseCaseImpl(getIt.get()));

  getIt.registerFactory<GetPetDetailUseCase>(
      () => GetPetDetailUseCaseImpl(getIt.get()));
}

void setupMockUsecase() {
  getIt.registerFactory<GetPetsUseCase>(() => MockGetPetsUseCase());
  getIt.registerFactory<AdoptPetUseCase>(() => MockAdoptPetsUseCase());
  getIt.registerFactory<GetPetDetailUseCase>(
      () => GetPetDetailUseCaseImpl(getIt.get()));
}
