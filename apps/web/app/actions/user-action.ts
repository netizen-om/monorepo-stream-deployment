"use server"
import { prismaClient } from "db/client";

export const getUsers = async() => {
    const users = await prismaClient.user.findMany();

    return users
}