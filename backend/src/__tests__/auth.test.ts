import request from "supertest";
import app from "../app";

describe("Auth API", () => {
  it("should register a new user", async () => {
    const res = await request(app)
      .post("/auth/register")
      .send({ email: "test@example.com", password: "test1234" });
    expect(res.statusCode).toBe(200);
    expect(res.body.success).toBe(true);
  });

  it("should login with correct credentials", async () => {
    await request(app)
      .post("/auth/register")
      .send({ email: "login@example.com", password: "test1234" });
    const res = await request(app)
      .post("/auth/login")
      .send({ email: "login@example.com", password: "test1234" });
    expect(res.statusCode).toBe(200);
    expect(res.body.token).toBeDefined();
  });
}); 