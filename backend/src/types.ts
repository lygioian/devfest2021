import { Request as ERequest, Response as EResponse } from 'express';
import { HttpResponseComposer } from './lib/response-composer';

export interface Request extends ERequest {}

export interface Response extends EResponse {
    composer?: HttpResponseComposer;
}

export const ServiceType = {
    Database: Symbol.for('DatabaseService'),
    Post: Symbol.for('PostService'),
};

export enum PrivacyType {
    PUBLIC = 'public',
    PROTECTED = 'protected',
    PRIVATE = 'private',
}

export enum HttpMethod {
    GET = 'GET',
    POST = 'POST',
    PUT = 'PUT',
    PATCH = 'PATCH',
    DELETE = 'DELETE',
}
