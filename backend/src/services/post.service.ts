import { injectable, inject } from 'inversify';
import { Collection, ObjectID } from 'mongodb';
import _ from 'lodash';

import { DatabaseService } from './database.service';
import { ServiceType } from '../types';
import { ErrorDeviceStatusInvalid } from '../lib/errors';
import { lazyInject } from '../container';

import { Post } from '../models/post.model';

@injectable()
export class PostService {
    private deviceStatusCollection: Collection;

    constructor(
        @inject(ServiceType.Database) private dbService: DatabaseService,
    ) {
        console.log('[Device status service] Construct');
        this.deviceStatusCollection = this.dbService.db.collection('post');
    }

    async create(post: Post): Promise<string> {
        post.media = [];
        const nums = new Set<number>();
        while (nums.size !== 5) {
            nums.add(Math.floor(Math.random() * (14 - 0 + 1) + 0));
        }

        nums.forEach((element) => {
            post.media.push(`https://api.devfest.top/static/${element}.jpeg`);
        });

        const addedDeviceStatus = await this.deviceStatusCollection.insertOne(
            post,
        );

        let newPost = addedDeviceStatus.ops[0] as Post;
        let postKey = newPost._id.toHexString();
        const updated = this.update(newPost._id, { postKey: postKey });
        return postKey;
    }

    async update(postId: ObjectID, data: any) {
        const opUpdateResult = await this.deviceStatusCollection.updateOne(
            {
                _id: postId,
            },
            { $set: data },
        );
        return opUpdateResult.result.nModified;
    }

    async validate(statusId: ObjectID) {
        const status = await this.deviceStatusCollection.findOne({
            _id: statusId,
        });
        if (_.isEmpty(status))
            throw new ErrorDeviceStatusInvalid('Device status not found');
        return true;
    }

    async delete(statusId: ObjectID) {
        return this.deviceStatusCollection.deleteOne(statusId);
    }

    async findOne(query: any = {}, keepAll = false): Promise<Post> {
        const status = (await this.deviceStatusCollection.findOne(
            query,
        )) as Post;

        if (_.isEmpty(status))
            throw new ErrorDeviceStatusInvalid('Post not found');
        return keepAll ? status : (_.omit(status) as Post);
    }

    async find(
        query: any = {},
        populate = false,
        limit = 10,
        simplify = false,
    ): Promise<Post[]> {
        let aggreateCommand: any[] = [{ $match: query }];

        // if (populate)
        //     aggreateCommand = this.populateDeviceStatus(aggreateCommand);

        const status = await this.deviceStatusCollection
            .aggregate(aggreateCommand)
            .toArray();

        return status;
    }

    private populateDeviceStatus(aggreateCommand: any) {
        return _.concat(aggreateCommand, [
            {
                $lookup: {
                    from: 'posts',
                    localField: 'deviceId',
                    foreignField: '_id',
                    as: 'device',
                },
            },
            { $unwind: '$device' },
        ]);
    }
}
