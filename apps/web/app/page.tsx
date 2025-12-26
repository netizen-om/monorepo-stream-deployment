import { getUser } from "./action/user-action";

export default async function Home() {
    const users = await getUser();
  return (
    <div>
        USERS : 
        {JSON.stringify(users)}
    </div>
  );
}
