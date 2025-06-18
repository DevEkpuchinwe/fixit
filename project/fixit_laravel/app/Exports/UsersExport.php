<?php

namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithHeadings;

class UsersExport implements FromCollection, WithMapping, WithHeadings
{
    public function collection()
    {
        $users = User::whereHas('roles', function ($query) {
            $query->where('system_reserve', 0);
        });
        
        return $this->filter($users, request()->all());
    }

    /**
     * Specify the columns for the export.
     *
     * @return array
     */
    public function columns(): array
    {
        return [
           'name',
           'email',
           'code',
           'phone',
           'status',
           'password',
        ];
    }

    public function map($user): array
    {
        return [
            $user->name,
            $user->email,
            $user->code,
            $user->phone,
            $user->status,
            $user->password,
        ];
    }

     /**
     * Get the headings for the export file.
     *
     * @return array
     */
    public function headings(): array
    {
        return [
            'name',
            'email',
            'code',
            'phone',
            'status',
            'password',
        ];
    }

    public function filter($users, $request)
    {

        return $users->get();
    }
}
