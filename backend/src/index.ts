import 'reflect-metadata';

import { App } from './app';
import container from './container';
import { SERVICE_PORT } from './config';
import { applyHttpResponseComposer } from './lib/response-composer';

import { DatabaseService, PostService } from './services';
import { PostController } from './controllers';
import { ServiceType } from './types';

// Binding service
container
    .bind<DatabaseService>(ServiceType.Database)
    .to(DatabaseService)
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
        [container.resolve<PostController>(PostController)],
        SERVICE_PORT,
        [applyHttpResponseComposer],
    );

    app.listen();
});
