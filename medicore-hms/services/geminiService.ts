import { GoogleGenAI } from "@google/genai";
import { MedicalRecord, Patient } from "../types";

// Helper to initialize AI. 
// Note: In a real app, ensure process.env.API_KEY is defined.
// If not defined, we will mock the response or throw an error handled by UI.
const getAIClient = () => {
  const apiKey = process.env.API_KEY;
  if (!apiKey) return null;
  return new GoogleGenAI({ apiKey });
};

export const summarizePatientHistory = async (patient: Patient, records: MedicalRecord[]): Promise<string> => {
  const ai = getAIClient();
  
  // If no API key, return a mock message to prevent app crash in demo mode without key
  if (!ai) {
    return "AI summarization unavailable. Please configure process.env.API_KEY to enable Gemini features. (Simulated: The patient has a history of hypertension effectively managed with medication.)";
  }

  const prompt = `
    You are a medical assistant. Summarize the medical history for the following patient in a concise paragraph for a doctor to review quickly.
    
    Patient: ${patient.name}, ${patient.gender}, Born: ${patient.dob}
    Conditions: ${patient.chronicConditions.join(', ')}
    Allergies: ${patient.allergies.join(', ')}
    
    Recent Medical Records:
    ${records.slice(0, 5).map(r => `- ${r.date}: ${r.diagnosis} (${r.type})`).join('\n')}
    
    Keep it professional, clinical, and under 100 words.
  `;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-3-flash-preview',
      contents: prompt,
    });
    return response.text || "No summary generated.";
  } catch (error) {
    console.error("Gemini API Error:", error);
    return "Failed to generate summary due to an API error.";
  }
};
