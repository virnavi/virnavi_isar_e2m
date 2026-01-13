import 'dart:async';
import 'package:example/domain/database/dao/user_dao.dart';
import 'package:example/domain/models/models.dart';
import 'package:example/ui/home/cubits/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virnavi_isar_e2m/virnavi_isar_e2m.dart';

class UserCubit extends Cubit<UserState> {
  final UserDao _userDao;
  StreamSubscription? _subscription;

  UserCubit(this._userDao) : super(const UserState()) {
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    final userStream = await _userDao.getByIdWatcher(DbConstants.singletonId);
    _subscription = userStream.listen((userOptional) {
      if (userOptional.hasData) {
        emit(state.copyWith(user: userOptional.data));
      } else {
        emit(state.copyWith(user: UserModel.empty()));
      }
    });
  }

  Future<void> updateUser(UserModel user) async {
    await _userDao.upsert(user);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
