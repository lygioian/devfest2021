import { ObjectID } from 'mongodb';

export interface Post {
    _id?: ObjectID;
    title: string;
    name: string;
    tel: string;
    description: string;
    requestHelp: string;
    coordinates: string[];
    address: string;
    media: string[];
    createdAt: number;
    postKey: string;
}
