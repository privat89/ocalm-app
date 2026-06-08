import { Module, Global } from '@nestjs/common';
import knex, { Knex } from 'knex';

const DATABASE_TOKEN = 'DATABASE_CONNECTION';

@Global()
@Module({
  providers: [
    {
      provide: DATABASE_TOKEN,
      useFactory: (): Knex => {
        return knex({
          client: 'pg',
          connection: process.env.DATABASE_URL || 'postgresql://ocalm_user:ocalm_secret_2025@localhost:5432/ocalm',
          pool: { min: 2, max: 10 },
        });
      },
    },
  ],
  exports: [DATABASE_TOKEN],
})
export class DatabaseModule {}
