import { injectable, inject } from 'inversify';
import { Collection, ObjectID } from 'mongodb';
import _ from 'lodash';

import { DatabaseService } from './database.service';
import { ServiceType } from '../types';
import { ErrorDeviceStatusInvalid } from '../lib/errors';

import { Post } from '../models/post.model';

export const USER_FORBIDDEN_FIELDS = ['postKey'];

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
        let postKey =
            Math.floor(Math.random() * (20000000 - 0 + 1) + 100012) +
            newPost._id.toHexString();
        const updated = this.updateById(newPost._id, { postKey: postKey });
        return postKey;
    }

    async updateById(id: ObjectID, data: any) {
        const opUpdateResult = await this.deviceStatusCollection.updateOne(
            {
                _id: id,
            },
            { $set: data },
        );
        return opUpdateResult.result.nModified;
    }

    async update(postId: string, data: any) {
        const opUpdateResult = await this.deviceStatusCollection.updateOne(
            {
                postKey: postId,
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

    async delete(key: string) {
        return this.deviceStatusCollection.deleteOne({ postKey: key });
    }

    async findOne(query: any = {}, keepAll = false): Promise<Post> {
        const status = (await this.deviceStatusCollection.findOne(
            query,
        )) as Post;

        if (_.isEmpty(status))
            throw new ErrorDeviceStatusInvalid('Post not found');
        return keepAll
            ? status
            : (_.omit(status, USER_FORBIDDEN_FIELDS) as Post);
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
        return status.map((e) => _.omit(e, USER_FORBIDDEN_FIELDS) as Post);
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
