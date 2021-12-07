import path from 'path';

export const IS_PRODUCTION = process.env.NODE_ENV == 'production';

export const SERVICE_PORT = +process.env.PORT || 3031;

export const SERVICE_NAME = 'LINKUP';

export const FE_ADDRESS = IS_PRODUCTION
    ? 'https://bugs.vn/'
    : 'http://localhost:5000/';

export const DB_NAME = 'test';
export const DB_CONN_STRING =
    'mongodb+srv://admin:123@cluster0-obkrz.mongodb.net/test?authSource=admin&replicaSet=Cluster0-shard-0&w=majority&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=true';
// export const DB_CONN_STRING = `mongodb://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?authSource=${DB_NAME}`;

export const HASH_ROUNDS = 10;
export const PASSWORD_SCERET_KEY = 'AQ!@(!NFAJF*((!@#*(R)!U__*#';
export const JWT_SECRET =
    '4A7F95E8D85601B138CDE8172C64A0AB5E6BBDECD9897E0BBB344143AD0CD2D1B8286939BA2FA9AB2299DF70A847B443B8DDB3C25FB7184B17A98D27D4FD420D1631A9';

export const WORKING_DIR = path.resolve(process.env.WORKING_DIR);
export const STATIC_DIR = path.join(WORKING_DIR, 'static');
export const UPLOAD_DIR = path.join(WORKING_DIR, 'uploads');

console.log('WORKING_DIR', WORKING_DIR);
console.log('STATIC_DIR', STATIC_DIR);
console.log('UPLOAD_DIR', UPLOAD_DIR);
