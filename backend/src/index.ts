import 'reflect-metadata';

import { App } from './app';
import container from './container';
import { SERVICE_PORT } from './config';
import { applyHttpResponseComposer } from './lib/response-composer';

import {
    AuthService,
    DatabaseService,
    UserService,
    BundleService,
    UploadService,
    MailService,
    PostService,
} from './services';
import {
    AuthController,
    UserController,
    BundleController,
    MeController,
    UploadController,
    PostController,
} from './controllers';
import { ServiceType } from './types';

// Binding service
container
    .bind<AuthService>(ServiceType.Auth)
    .to(AuthService)
    .inSingletonScope();
container
    .bind<DatabaseService>(ServiceType.Database)
    .to(DatabaseService)
    .inSingletonScope();
container
    .bind<UserService>(ServiceType.User)
    .to(UserService)
    .inSingletonScope();
container
    .bind<BundleService>(ServiceType.Bundle)
    .to(BundleService)
    .inSingletonScope();
container
    .bind<UploadService>(ServiceType.Upload)
    .to(UploadService)
    .inSingletonScope();
container
    .bind<MailService>(ServiceType.Mail)
    .to(MailService)
    .inSingletonScope();
container
    .bind<PostService>(ServiceType.Post)
    .to(PostService)
    .inSingletonScope();

// Initialize service first
Promise.all([
    container.get<DatabaseService>(ServiceType.Database).initialize(),
]).then(() => {
    const app = new App(
        [
            container.resolve<AuthController>(AuthController),
            container.resolve<UserController>(UserController),
            container.resolve<BundleController>(BundleController),
            container.resolve<MeController>(MeController),
            container.resolve<UploadController>(UploadController),
            container.resolve<PostController>(PostController),
        ],
        SERVICE_PORT,
        [
            applyHttpResponseComposer,
            container.get<AuthService>(ServiceType.Auth).applyMiddleware(),
        ],
    );

    app.listen();
});
