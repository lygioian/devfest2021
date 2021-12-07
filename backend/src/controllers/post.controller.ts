import { Router } from 'express';
import { inject, injectable } from 'inversify';
import _ from 'lodash';
import { ObjectID } from 'bson';
import { Request, Response, ServiceType } from '../types';
import { Controller } from './controller';
import {
    UploadService,
    AuthService,
    MailService,
    PostService,
} from '../services';
import { User } from '../models/user.model';
import { UPLOAD_DIR, EMAIL_SENDER } from '../config';

@injectable()
export class PostController extends Controller {
    public readonly router = Router();
    public readonly path = '/post';

    constructor(@inject(ServiceType.Post) private postService: PostService) {
        super();

        this.router.post('/', this.createPost.bind(this));
        this.router.get('/', this.getPost.bind(this));
        this.router.get('/:postId', this.getPostById.bind(this));
        this.router.patch('/', this.updatePost.bind(this));
    }

    async createPost(req: Request, res: Response) {
        try {
            const createdSlug = await this.postService.create(req.body);
            res.composer.success(
                { post_key: createdSlug },
                'Create Post Success',
            );
        } catch (error) {
            console.log(error);
            res.composer.badRequest(error.message);
        }
    }

    async getPost(req: Request, res: Response) {
        try {
            const createdSlug = await this.postService.find();
            res.composer.success(createdSlug, 'Get Post Success');
        } catch (error) {
            console.log(error);
            res.composer.badRequest(error.message);
        }
    }

    async getPostById(req: Request, res: Response) {
        try {
            const id = ObjectID.createFromHexString(req.params.postId);
            console.log(id);
            const createdSlug = await this.postService.findOne({ _id: id });
            res.composer.success(createdSlug);
        } catch (error) {
            console.log(error);
            res.composer.badRequest(error.message);
        }
    }

    async updatePost(req: Request, res: Response) {
        try {
            const createdSlug = await this.postService.create(req.body);
            res.composer.success(
                { post_key: createdSlug },
                'Create Post Success',
            );
        } catch (error) {
            console.log(error);
            res.composer.badRequest(error.message);
        }
    }
}
