import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:picnic_app/core/domain/model/paginated_list.dart';
import 'package:picnic_app/core/domain/stores/user_store.dart';
import 'package:picnic_app/dependency_injection/app_component.dart';
import 'package:picnic_app/features/feed/circles_side_menu/circles_side_menu_initial_params.dart';
import 'package:picnic_app/features/feed/circles_side_menu/circles_side_menu_navigator.dart';
import 'package:picnic_app/features/feed/circles_side_menu/circles_side_menu_page.dart';
import 'package:picnic_app/features/feed/circles_side_menu/circles_side_menu_presentation_model.dart';
import 'package:picnic_app/features/feed/circles_side_menu/circles_side_menu_presenter.dart';

import '../../../mocks/mocks.dart';
import '../../../mocks/stubs.dart';
import '../../../test_utils/golden_tests_utils.dart';
import '../../../test_utils/test_utils.dart';
import '../../circles/mocks/circles_mocks.dart';
import '../../pods/mocks/pods_mocks.dart';

Future<void> main() async {
  late CirclesSideMenuPage page;
  late CirclesSideMenuInitialParams initParams;
  late CirclesSideMenuPresentationModel model;
  late CirclesSideMenuPresenter presenter;
  late CirclesSideMenuNavigator navigator;

  void initMvp() {
    reRegister<UserStore>(Mocks.userStore);
    when(() => Mocks.userStore.privateProfile).thenReturn(Stubs.privateProfile);
    initParams = CirclesSideMenuInitialParams(onCircleSideMenuAction: () {});
    model = CirclesSideMenuPresentationModel.initial(
      initParams,
      Mocks.userStore,
    );
    navigator = CirclesSideMenuNavigator(Mocks.appNavigator);

    when(
      () => CirclesMocks.getLastUsedCirclesUseCase.execute(
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer((invocation) => successFuture(const PaginatedList.empty()));

    when(
      () => PodsMocks.getSavedPodsUseCase.execute(
        nextPageCursor: any(named: 'nextPageCursor'),
      ),
    ).thenAnswer((invocation) => successFuture(const PaginatedList.empty()));
    when(
      () => Mocks.getCollectionsUseCase.execute(
        nextPageCursor: any(named: 'nextPageCursor'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => successFuture(const PaginatedList.empty()));
    when(
      () => Mocks.circlesRepository.getLastUsedCircles(
        nextPageCursor: any(named: 'nextPageCursor'),
      ),
    ).thenAnswer((invocation) => successFuture(const PaginatedList.empty()));

    presenter = CirclesSideMenuPresenter(
      model,
      navigator,
      CirclesMocks.getLastUsedCirclesUseCase,
      Mocks.getCollectionsUseCase,
      PodsMocks.getSavedPodsUseCase,
    );

    getIt.registerFactoryParam<CirclesSideMenuPresenter, CirclesSideMenuInitialParams, dynamic>(
      (initialParams, _) => presenter,
    );
    page = CirclesSideMenuPage(initialParams: initParams);
  }

  await screenshotTest(
    "circles_side_menu_page",
    setUp: () async {
      initMvp();
    },
    pageBuilder: () => page,
  );
}
