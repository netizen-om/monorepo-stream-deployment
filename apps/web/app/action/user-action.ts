import { prismaClient } from "@repo/db/client";

export const getUser = async() => {
    try {
        const users = await prismaClient.user.findMany();

        return users
    } catch (error) {
        console.log(error);
        
    }
} 