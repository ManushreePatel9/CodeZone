package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import jakarta.mail.internet.MimeMessage;

@Service
public class MailerService {
    
    @Autowired
    private JavaMailSender mailSender;
    
    
    public void sendJudgeCredentialsMail(String receiverEmail, String firstName, String password) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(receiverEmail);
            helper.setSubject("Welcome to SkillAcademy! Your Judge Access is Ready ⚖️");

            String loginUrl = "http://localhost:9999/login";

            String htmlContent = """
                <html>
                    <body style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f3f4f6; padding: 20px; color: #1f2937;">
                        <table align="center" width="600" style="background: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0px 10px 25px rgba(0,0,0,0.1); border: 1px solid #e5e7eb;">
                            <tr>
                                <td style="padding: 40px; text-align: center; background: linear-gradient(135deg, #4f46e5, #6366f1); color: white;">
                                    <div style="font-size: 50px; margin-bottom: 15px;">⚖️</div>
                                    <h1 style="margin: 0; font-size: 26px; letter-spacing: 1px;">Judge Account Created</h1>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 40px;">
                                    <h2 style="color: #4f46e5; margin-top: 0;">Hello, %s! 👋</h2>
                                    <p style="font-size: 16px; line-height: 1.6; color: #4b5563;">
                                        Admin has added you as a <b>Judge</b> on the SkillAcademy platform. You can now login to review submissions and evaluate hackathon projects.
                                    </p>
                                    
                                    <div style="background-color: #f9fafb; border-radius: 12px; padding: 25px; margin: 30px 0; border: 1px solid #e5e7eb; text-align: center;">
                                        <h4 style="margin: 0 0 15px 0; color: #6b7280; text-transform: uppercase; font-size: 13px; letter-spacing: 1px;">Your Login Credentials</h4>
                                        
                                        <p style="margin: 5px 0; font-size: 16px;"><strong>Email:</strong> <span style="color: #4f46e5;">%s</span></p>
                                        <p style="margin: 5px 0; font-size: 16px;"><strong>Password:</strong> <span style="color: #4f46e5; background: #eef2ff; padding: 2px 8px; border-radius: 4px;">%s</span></p>
                                    </div>

                                    <div style="text-align: center; margin: 35px 0;">
                                        <a href="%s" 
                                           style="background: #4f46e5; color: white; padding: 16px 35px; 
                                                  text-decoration: none; font-size: 17px; 
                                                  border-radius: 10px; font-weight: bold; display: inline-block;
                                                  box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);">
                                            Login to Dashboard
                                        </a>
                                    </div>

                                    <p style="font-size: 13px; color: #9ca3af; text-align: center; font-style: italic;">
                                        Security Tip: We recommend changing your password after your first successful login.
                                    </p>

                                    <hr style="border: 0; border-top: 1px solid #f3f4f6; margin: 30px 0;">
                                    
                                    <p style="font-size: 14px; color: #6b7280; text-align: center;">
                                        Welcome aboard!<br>
                                        <strong>SkillAcademy Admin Team</strong>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </body>
                </html>
            """.formatted(firstName, receiverEmail, password, loginUrl);

            helper.setText(htmlContent, true);
            mailSender.send(message);

            System.out.println("✅ Judge Credentials Mail sent to: " + receiverEmail);

        } catch (Exception e) {
            System.err.println("❌ Failed to send Judge Credentials Mail: " + e.getMessage());
        }
    }
    
    
    public void sendOtpMail(String receiverEmail, String otp) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(receiverEmail);
            helper.setSubject("Security: Your OTP for Password Reset 🔐");

            String htmlContent = """
                <html>
                    <body style="font-family: 'Segoe UI', sans-serif; background-color: #f4f7fa; padding: 20px;">
                        <table align="center" width="500" style="background: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                            <tr>
                                <td style="padding: 30px; text-align: center; background: #4f46e5; color: white;">
                                    <h2 style="margin: 0; font-size: 20px;">Verification Code</h2>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 40px; text-align: center;">
                                    <p style="font-size: 16px; color: #475569;">Hello, use the following OTP to reset your password:</p>
                                    <div style="margin: 30px 0; padding: 15px; background: #f8fafc; border: 2px dashed #cbd5e1; border-radius: 8px;">
                                        <span style="font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #1e293b;">%s</span>
                                    </div>
                                    <p style="font-size: 13px; color: #94a3b8;">This OTP is valid for a limited time. Do not share it with anyone.</p>
                                </td>
                            </tr>
                        </table>
                    </body>
                </html>
            """.formatted(otp);

            helper.setText(htmlContent, true);
            mailSender.send(message);
            System.out.println("✅ OTP Mail sent to: " + receiverEmail);
        } catch (Exception e) {
            System.err.println("❌ OTP Mail Error: " + e.getMessage());
        }
    }
    
    public void sendRemovalMail(String receiverEmail, String teamName, String programName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            // true flag ka matlab hum HTML content aur images bhej sakte hain
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(receiverEmail);
            helper.setSubject("Important: Team Membership Update - " + teamName);

            String htmlContent = """
                <html>
                    <body style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8fafc; padding: 20px; color: #333;">
                        <table align="center" width="600" style="background: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0px 4px 20px rgba(0,0,0,0.05); border: 1px solid #e2e8f0;">
                            <tr>
                                <td style="padding: 30px; text-align: center; background: #fee2e2; border-bottom: 2px solid #fecaca;">
                                    <div style="font-size: 40px; margin-bottom: 10px;">👤🚫</div>
                                    <h2 style="margin: 0; color: #dc2626; font-size: 22px;">Membership Update</h2>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 40px;">
                                    <p style="font-size: 16px; color: #475569; line-height: 1.6;">
                                        Hello,
                                    </p>
                                    <p style="font-size: 16px; color: #475569; line-height: 1.6;">
                                        This is a notification to inform you that you have been removed from 
                                        <strong style="color: #1e293b;">Team %s</strong> for the hackathon 
                                        <strong style="color: #8b5cf6;">%s</strong>.
                                    </p>
                                    
                                    <div style="background-color: #f1f5f9; border-radius: 12px; padding: 20px; margin: 25px 0; border-left: 4px solid #94a3b8;">
                                        <p style="margin: 0; font-size: 14px; color: #64748b;">
                                            <strong>What does this mean?</strong><br>
                                            You are now eligible to join another team or create your own squad for this competition. Your pending requests for other teams remain unaffected.
                                        </p>
                                    </div>

                                    <div style="text-align: center; margin: 30px 0;">
                                        <a href="http://localhost:9999/pDashboard" 
                                           style="background: #475569; color: white; padding: 12px 25px; 
                                                  text-decoration: none; font-size: 15px; 
                                                  border-radius: 8px; font-weight: bold; display: inline-block;">
                                            Back to Dashboard
                                        </a>
                                    </div>

                                    <p style="font-size: 13px; color: #94a3b8; text-align: center;">
                                        If you believe this happened by mistake, please contact the Team Leader directly.
                                    </p>

                                    <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">
                                    
                                    <p style="font-size: 14px; color: #64748b; text-align: center;">
                                        Regards,<br>
                                        <strong>SkillAcademy Support Team</strong>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </body>
                </html>
            """.formatted(teamName, programName);

            helper.setText(htmlContent, true);
            mailSender.send(message);

            System.out.println("✅ Removal email successfully sent to: " + receiverEmail);

        } catch (Exception e) {
            System.err.println("❌ Error sending removal email: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void sendHackathonInvitation(String receiverEmail, String senderName, String programName, String programId) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(receiverEmail);
            helper.setSubject("Special Invitation: Join " + senderName + " for " + programName + "! 🚀");

            // Signup URL banayein (taaki ye formatted mein pass ho sake)
            String signupUrl = "http://localhost:9999/?email=" + receiverEmail;

            String htmlContent = """
                <html>
                    <body style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; padding: 20px; color: #333;">
                        <table align="center" width="600" style="background: #ffffff; border-radius: 15px; overflow: hidden; box-shadow: 0px 10px 30px rgba(0,0,0,0.1);">
                            <tr>
                                <td style="padding: 40px; text-align: center; background: linear-gradient(135deg, #8b5cf6, #3b82f6); color: white;">
                                    <h1 style="margin: 0; font-size: 28px;">You're Invited! 🏆</h1>
                                    <p style="font-size: 16px; opacity: 0.9; margin-top: 10px;">Collaborate & Build Something Great</p>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 40px;">
                                    <h2 style="color: #1e293b; margin-top: 0;">Hello! 👋</h2>
                                    <p style="font-size: 16px; line-height: 1.6; color: #475569;">
                                        <b>%s</b> has invited you to join their team for the upcoming hackathon: 
                                        <span style="color: #8b5cf6; font-weight: bold;">%s</span>.
                                    </p>
                                    
                                    <div style="background-color: #f8fafc; border-radius: 10px; padding: 20px; margin: 25px 0; border: 1px solid #e2e8f0;">
                                        <h4 style="margin-top: 0; color: #8b5cf6; border-bottom: 2px solid #8b5cf6; display: inline-block;">How to Join the Team:</h4>
                                        <ol style="font-size: 15px; line-height: 1.8; color: #475569; padding-left: 20px;">
                                            <li><b>Login/Sign Up:</b> Click the button below to go to SkillAcademy.</li>
                                            <li><b>Check Requests:</b> Go to your Notifications or "View Requests" section.</li>
                                            <li><b>Accept Invite:</b> Find the invitation from %s and click <b>Accept</b>.</li>
                                        </ol>
                                    </div>

                                    <div style="text-align: center; margin: 35px 0;">
                                        <a href="%s" 
                                           style="background: #8b5cf6; color: white; padding: 16px 32px; 
                                                  text-decoration: none; font-size: 18px; 
                                                  border-radius: 12px; font-weight: bold; display: inline-block;
                                                  box-shadow: 0 4px 15px rgba(139, 92, 246, 0.4);">
                                            View Invitation & Join
                                        </a>
                                    </div>

                                    <p style="font-size: 13px; color: #94a3b8; line-height: 1.5;">
                                        <b>Note:</b> If you don't have an account yet, please register with <i>%s</i> to see this pending request.
                                    </p>

                                    <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">
                                    
                                    <p style="font-size: 14px; color: #475569;">
                                        Happy Coding,<br>
                                        <strong>The SkillAcademy Team</strong>
                                    </p>
                                </td>
                            </tr>
                            <tr>
                                <td style="background: #f1f5f9; text-align: center; padding: 20px; color: #94a3b8; font-size: 12px;">
                                    © 2026 SkillAcademy. Connect with creators worldwide.
                                </td>
                            </tr>
                        </table>
                    </body>
                </html>
            """.formatted(senderName, programName, senderName, signupUrl, receiverEmail);

            helper.setText(htmlContent, true);
            mailSender.send(message);

            System.out.println("✅ Invitation Email sent to " + receiverEmail);

        } catch (Exception e) {
            e.printStackTrace(); 
            System.err.println("❌ Failed to send email: " + e.getMessage());
        }
    }
    
    public void sendSpotAvailableMail(String receiverEmail, String teamName, String programName, Integer pid) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(receiverEmail);
            // Subject line exciting honi chahiye
            helper.setSubject("🔥 Urgent: A spot just opened up in Team " + teamName + "!");

            String loginUrl = "http://localhost:9999/viewHackathon?pid=" + pid;

            String htmlContent = """
                <html>
                    <body style="font-family: 'Inter', sans-serif; background-color: #070b14; padding: 20px; color: #f1f5f9;">
                        <table align="center" width="600" style="background: #111827; border: 1px solid #1f2937; border-radius: 20px; overflow: hidden;">
                            <tr>
                                <td style="padding: 40px; text-align: center; background: linear-gradient(135deg, #06b6d4, #3b82f6);">
                                    <div style="font-size: 50px; margin-bottom: 10px;">⚡</div>
                                    <h1 style="margin: 0; font-size: 26px; color: white; text-transform: uppercase; letter-spacing: 1px;">Spot Available!</h1>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 40px;">
                                    <h2 style="color: #06b6d4; margin-top: 0;">Time is running out! ⏳</h2>
                                    <p style="font-size: 16px; line-height: 1.6; color: #9ca3af;">
                                        Great news! A member just left <b>Team %s</b> for the <b>%s</b>. 
                                        Since you had a pending invitation, you're the first to know!
                                    </p>
                                    
                                    <div style="background: rgba(6, 182, 212, 0.1); border: 1px dashed #06b6d4; border-radius: 12px; padding: 20px; margin: 25px 0; text-align: center;">
                                        <span style="color: #06b6d4; font-weight: bold; font-size: 14px; display: block; margin-bottom: 5px;">FIRST COME, FIRST SERVED</span>
                                        <p style="margin: 0; font-size: 15px; color: #e5e7eb;">
                                            There is only <b>1 slot</b> remaining. Once it's filled, the team will be locked again.
                                        </p>
                                    </div>

                                    <div style="text-align: center; margin: 35px 0;">
                                        <a href="%s" 
                                           style="background: #06b6d4; color: white; padding: 16px 40px; 
                                                  text-decoration: none; font-size: 18px; 
                                                  border-radius: 12px; font-weight: bold; display: inline-block;
                                                  box-shadow: 0 4px 20px rgba(6, 182, 212, 0.3);">
                                            Claim Your Spot Now
                                        </a>
                                    </div>

                                    <p style="font-size: 13px; color: #6b7280; text-align: center;">
                                        If the link doesn't work, login to your dashboard and check your "Pending Requests".
                                    </p>

                                    <hr style="border: 0; border-top: 1px solid #1f2937; margin: 30px 0;">
                                    
                                    <p style="font-size: 14px; color: #9ca3af; text-align: center;">
                                        Best of luck!<br>
                                        <strong>SkillAcademy Competition Desk</strong>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </body>
                </html>
            """.formatted(teamName, programName, loginUrl);

            helper.setText(htmlContent, true);
            mailSender.send(message);

        } catch (Exception e) {
            System.err.println("❌ Spot Alert Mail Failed: " + e.getMessage());
        }
    }
    
    
    public void sendRegistrationSuccessMail(String receiverEmail, String teamName, String programName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(receiverEmail);
            helper.setSubject("Registration Confirmed! 🎊 Team " + teamName + " is officially in!");

            String htmlContent = """
                <html>
                    <body style="font-family: 'Segoe UI', sans-serif; background-color: #070b14; padding: 20px; color: #f1f5f9;">
                        <table align="center" width="600" style="background: #111827; border: 1px solid #10b981; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(16, 185, 129, 0.2);">
                            <tr>
                                <td style="padding: 40px; text-align: center; background: linear-gradient(135deg, #10b981, #059669); color: white;">
                                    <div style="font-size: 50px; margin-bottom: 10px;">🎉</div>
                                    <h1 style="margin: 0; font-size: 26px; text-transform: uppercase; letter-spacing: 2px;">Registration Confirmed</h1>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 40px;">
                                    <h2 style="color: #10b981; margin-top: 0;">Congratulations! 🚀</h2>
                                    <p style="font-size: 16px; line-height: 1.6; color: #9ca3af;">
                                        Your team <strong style="color: #f1f5f9;">%s</strong> has been successfully registered for 
                                        <strong style="color: #8b5cf6;">%s</strong>.
                                    </p>
                                    
                                    <div style="background: rgba(16, 185, 129, 0.1); border-radius: 12px; padding: 20px; margin: 25px 0; border: 1px solid rgba(16, 185, 129, 0.3);">
                                        <p style="margin: 0; font-size: 15px; color: #e5e7eb; text-align: center;">
                                            <strong>The squad is locked. The challenge awaits.</strong><br>
                                            You can no longer add or remove members from this team.
                                        </p>
                                    </div>

                                    <div style="text-align: center; margin: 30px 0;">
                                        <a href="http://localhost:9999/dashboard" 
                                           style="background: #10b981; color: white; padding: 14px 30px; 
                                                  text-decoration: none; font-size: 16px; 
                                                  border-radius: 10px; font-weight: bold; display: inline-block;">
                                            Go to Dashboard
                                        </a>
                                    </div>

                                    <p style="font-size: 13px; color: #6b7280; text-align: center;">
                                        Make sure to check the event timeline and rules on the hackathon page.
                                    </p>

                                    <hr style="border: 0; border-top: 1px solid #1f2937; margin: 30px 0;">
                                    
                                    <p style="font-size: 14px; color: #9ca3af; text-align: center;">
                                        Best of luck for the competition!<br>
                                        <strong>SkillAcademy Support</strong>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </body>
                </html>
            """.formatted(teamName, programName);

            helper.setText(htmlContent, true);
            mailSender.send(message);
            System.out.println("✅ Registration Success Mail sent to: " + receiverEmail);

        } catch (Exception e) {
            System.err.println("❌ Failed to send registration success mail: " + e.getMessage());
        }
    }
    
    
}