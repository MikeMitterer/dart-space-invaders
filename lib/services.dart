library spaceinvaders.services;

import 'package:m4d_core/m4d_ioc.dart';
import 'components/interface/store.dart' as store;

const SpaceInvadersStore = Service<store.SpaceInvadersStore>(
    "spaceinvaders.services.SpaceInvadersStore",ServiceType.Instance);

