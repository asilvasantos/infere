from openai import OpenAI

#API_KEY ="token chatgpt"
client = OpenAI(api_key=API_KEY)

prompt = """
Qual a UF e a região da UG BASE AEREA DE FORTALEZA?
Responda em JSON.
"""

response = client.chat.completions.create(
    model="gpt-4.1-mini",
    messages=[{"role": "user", "content": prompt}]
)

print(response.choices[0].message.content)