import { Router } from 'express';
import { inject, injectable } from 'inversify';
import _ from 'lodash';
import { ObjectID } from 'bson';
import { Request, Response, ServiceType } from '../types';
import { Controller } from './controller';
import { PostService } from '../services';

@injectable()
export class PostController extends Controller {
    public readonly router = Router();
    public readonly path = '/post';

    constructor(@inject(ServiceType.Post) private postService: PostService) {
        super();

        this.router.post('/', this.createPost.bind(this));
        this.router.get('/', this.getPost.bind(this));
        this.router.get('/:postId', this.getPostById.bind(this));
        this.router.patch('/:postKey', this.updatePost.bind(this));
        this.router.delete('/:postKey', this.deletePost.bind(this));
    }

    async createPost(req: Request, res: Response) {
        try {
            const createdSlug = await this.postService.create(req.body);
            res.composer.success(
                { postKey: createdSlug },
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
            const createdSlug = await this.postService.update(
                req.params.postKey,
                req.body,
            );
            res.composer.success(createdSlug, 'Update Post Success');
        } catch (error) {
            console.log(error);
            res.composer.badRequest(error.message);
        }
    }

    async deletePost(req: Request, res: Response) {
        try {
            const createdSlug = await this.postService.delete(
                req.params.postKey,
            );
            res.composer.success({}, 'Delete Post Success');
        } catch (error) {
            console.log(error);
            res.composer.badRequest(error.message);
        }
    }
}
